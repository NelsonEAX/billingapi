# -*- coding: utf-8 -*-
'''The file contains functions for working with the database'''

import os
import base64
import time
import json
import random
import string

import sqlalchemy as sa
from aiopg.sa import create_engine
from aiohttp_session.cookie_storage import EncryptedCookieStorage
from envparse import env

# Reading settings file from
if os.path.isfile('../.env'):
    env.read_envfile('../.env')


def get_env(name):
    '''Get envairoment variable from os or .env'''
    return os.getenv(name) if os.getenv(name) is not None else env.str(name)


# Database connection parameters obtained from .env
def get_dsn():
    '''DB connection string
    :return:
    '''
    return f"dbname={get_env('PG_DATABASE')} user={get_env('PG_USERNAME')} " \
           f"password={get_env('PG_PASSWORD')} host={get_env('PG_SERVER')} " \
           f"port={get_env('PG_PORT')}"


def get_sekret_key():
    '''SECRET_KEY for the session
    :return:
    '''
    return EncryptedCookieStorage(base64.urlsafe_b64decode(get_env('SECRET_KEY')))


def get_timestamp_str():
    '''TimeStamp string of the current timestamp for the base
    :return:
    '''
    return time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))


METADATA = sa.MetaData()

CURRENCY = sa.Table(
    'currency',
    METADATA,
    sa.Column('id', sa.Integer, primary_key=True, autoincrement=True),
    sa.Column('title', sa.String(255)),
    sa.Column('code', sa.String(255)),
    sa.Column('symbol', sa.String(1)))

RATE = sa.Table(
    'rate',
    METADATA,
    # sa.Column('id', sa.Integer, primary_key=True, autoincrement=True),
    sa.Column('from', sa.Integer),
    sa.Column('to', sa.Integer),
    sa.Column('percent', sa.Float))

SETTINGS = sa.Table(
    'settings',
    METADATA,
    sa.Column('id', sa.Integer, primary_key=True, autoincrement=True),
    sa.Column('wallets', sa.ARRAY(sa.Integer)),
    sa.Column('currency', sa.Integer),
    sa.Column('balance', sa.Float),
    sa.Column('fee', sa.Float))

TRANSACTION = sa.Table(
    'transaction',
    METADATA,
    sa.Column('id', sa.Integer, primary_key=True, autoincrement=True),
    sa.Column('sender', sa.Integer),
    sa.Column('recipient', sa.Integer),
    sa.Column('info', sa.JSON),
    sa.Column('create_at', sa.TIMESTAMP))

WALLET = sa.Table(
    'wallet',
    METADATA,
    sa.Column('id', sa.Integer, primary_key=True, autoincrement=True),
    sa.Column('currency', sa.Integer),
    sa.Column('user', sa.Integer),
    sa.Column('account', sa.String(20)),
    sa.Column('balance', sa.Float))

USER = sa.Table(
    'user',
    METADATA,
    sa.Column('id', sa.Integer, primary_key=True, autoincrement=True),
    sa.Column('email', sa.String(255)),
    sa.Column('password', sa.String(255)),
    sa.Column('name', sa.String(255)),
    sa.Column('surname', sa.String(255)))


async def migrate_data(app):
    '''
    :param app:
    :return:
    '''
    async with app['pg_engine'].acquire() as conn:
        async for row in await conn.execute(
                '''select count(*) from INFORMATION_SCHEMA.tables
                where TABLE_SCHEMA = 'public' and TABLE_NAME in
                ('currency', 'rate', 'settings', 'transaction', 'wallet', 'user');'''):

            # If there is a base, exit
            if row[0] > 0:
                return

        with open('../pgsql/pg.sql', encoding='utf-8') as file:
            sql = '\n'.join(file.readlines())

        await conn.execute(
            f'''{sql}''')

        app['pg_engine'].close()
        app['pg_engine'] = await create_engine(get_dsn())

async def get_currencies(engine):
    '''
    :param engine:
    :return:
    '''
    async with engine.acquire() as conn:
        currencies = []
        async for row in await conn.execute(CURRENCY.select().order_by(CURRENCY.c.id)):
            currencies.append({'id': row[0], 'title': row[1], 'code': row[2], 'symbol': row[3]})
        return currencies


async def get_settings(engine):
    '''
    :param engine:
    :return:
    '''
    async with engine.acquire() as conn:
        async for row in await conn.execute(
                SETTINGS.select().order_by(sa.desc(SETTINGS.c.id)).limit(1)):
            return {
                'id': row[0],
                'wallets': row[1],
                'currency': row[2],
                'balance': row[3],
                'fee': row[4]}


async def get_rates(engine):
    '''
    :param engine:
    :return:
    '''
    async with engine.acquire() as conn:
        rates = []
        async for row in await conn.execute(
                '''select
                cf.title as from_title, cf.code as from_code, cf.symbol as from_symbol,
                r.from, r.to, r.percent,
                ct.title as to_title, ct.code as to_code, ct.symbol as to_symbol
                from rate r
                left join currency cf on cf.id = r.from
                left join currency ct on ct.id = r.to'''):
            rates.append({
                'from_title': row[0],
                'from_code': row[1],
                'from_symbol': row[2],
                'from': row[3],
                'to': row[4],
                'percent': row[5],
                'to_title': row[6],
                'to_code': row[7],
                'to_symbol': row[8]
            })
        return rates


async def get_user_by_email(engine, email):
    '''User existence check
    :param engine: DB connection
    :param email: user email
    :return: a list of users
    '''
    async with engine.acquire() as conn:
        async for row in conn.execute(USER.select().where(USER.c.email == email)):
            return {
                'id': row[0],
                'email': row[1],
                'password': row[2],
                'name': row[3],
                'surname': row[4]
            }


async def get_user_wallets(engine, user_id):
    '''User wallets
    :param engine: DB connection
    :param user_id: user id
    :return: a list of users
    '''
    async with engine.acquire() as conn:
        wallets = []
        async for row in await conn.execute(
                f'''select w.id, c.title, c.symbol, w.account, w.balance, w.currency
                from wallet as w
                left join currency as c on c.id = w.currency
                where w.user = {user_id};'''):
            wallets.append({
                'id': row[0],
                'title': row[1],
                'symbol': row[2],
                'account': row[3],
                'balance': row[4],
                'description': f'{row[3]} : {row[2]} {row[4]}',
                'currency': row[5]
            })

        return wallets


async def get_all_wallets(engine):
    '''All wallets
    :param engine: DB connection
    :return: a list of users
    '''
    async with engine.acquire() as conn:
        wallets = []
        async for row in await conn.execute(
                f'''select w.id, c.title, c.symbol, w.account, w.currency
                from wallet as w
                left join currency as c on c.id = w.currency;'''):
            wallets.append({
                'id': row[0],
                'title': row[1],
                'symbol': row[2],
                'account': row[3],
                'description': f'{row[3]} : {row[2]}',
                'currency': row[4]
            })

        return wallets


async def get_wallet(engine, account):
    '''
    :param engine:
    :param account:
    :return:
    '''
    async with engine.acquire() as conn:
        async for row in await conn.execute(
                f'''select w.id, w.balance, w.account, w.user, w.currency
                from wallet as w
                where w.account = '{account}';'''):
            return {
                'id': row[0],
                'balance': row[1],
                'account': row[2],
                'user': row[3],
                'currency': row[4]
            }


async def get_wallet_history(engine, wallet, datefrom, dateto):
    '''
    :param engine:
    :param wallet:
    :return:
    '''
    async with engine.acquire() as conn:
        transactions = []
        async for row in await conn.execute(
                f'''(
                    select
                        true as "from",
                        (-1.0 * (cast(t.info->>'amount_from' as decimal(10,2)
                        ) + cast(t.info->>'commission' as decimal(10,2)))) as sum,
                        ((t.info->>'wallet_to_before')::json->>'account') as wallet,
                        t.create_at as date
                    from "transaction" AS t
                    where t.sender = '{wallet}' and
                    t.create_at between '{datefrom} 00:00:00' and '{dateto} 23:59:59'
                )
                union
                (
                    select
                        false as "from",
                        cast(t2.info->>'amount_to' as decimal(10,2)) as sum,
                        ((t2.info->>'wallet_from_before')::json->>'account') as wallet,
                        t2.create_at as date
                    from "transaction" AS t2
                    where t2.recipient = '{wallet}' and
                    t2.create_at between '{datefrom} 00:00:00' and '{dateto} 23:59:59'
                )
                order by date;'''):
            transactions.append({
                'from': row[0],
                'sum': str(row[1]),
                'wallet': row[2],
                'date': str(row[3])
            })
        return transactions


async def get_rate(engine, currency_from, currency_to):
    '''
    :param engine:
    :param account:
    :return:
    '''
    if currency_from == currency_to:
        return 1.0

    async with engine.acquire() as conn:
        rate = await conn.scalar(
            f'''select "percent"
            from rate
            where "from" = {currency_from} and "to" = {currency_to};''')

        return 1.0 if rate is None else rate


async def create_user(engine, data):
    '''User creation
    :param engine: DB connection
    :param data: new user data
    :return:
    '''
    async with engine.acquire() as conn:
        user = await get_user_by_email(engine=engine, email=data['email'])
        if user is not None:
            raise Warning('A user with this email already exists.')

        user_id = await conn.scalar(USER.insert(None).values(
            email=data['email'],
            password=data['password'],
            name=data['name'],
            surname=data['surname']))

        # Create wallet for user from settings
        settings = await get_settings(engine=engine)
        for currency in settings['wallets']:
            account = ''.join(random.choice(string.digits) for _ in range(20))
            await conn.scalar(WALLET.insert(None).values(
                currency=currency,
                user=user_id,
                account=account,
                balance=settings['balance'] if settings['currency'] == currency else 0))
        return user_id


async def create_transaction(engine, wallet_from, wallet_to, info):
    '''
    If an error occurs, we will rollback the changes.
    And the balances will not change
    :param engine:
    :param wallet_from:
    :param wallet_to:
    :return:
    '''

    # Так мы точно работаем с текущими значениями, но в транзакции данные могут быть
    update_from = f'''update wallet
    set balance=balance - {info['amount_from']} 
    where account='{wallet_from['account']}';'''

    update_to = f'''update wallet
    set balance=balance + {info['amount_to']} 
    where account='{wallet_to['account']}';'''

    transaction = f'''insert into "transaction" (sender, recipient, info, create_at)
    VALUES('{wallet_from['account']}', '{wallet_to['account']}',
    '{json.dumps(info)}', '{get_timestamp_str()}');'''

    async with engine.acquire() as conn:
        await conn.execute(
            f'''BEGIN;
            {update_from}
            {update_to}
            {transaction}
            COMMIT;''')
