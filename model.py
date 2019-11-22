# -*- coding: utf-8 -*-
'''The file contains functions for working with the database'''

import base64
import time
import json
import random
import string
from os.path import isfile

import sqlalchemy as sa
from aiohttp_session.cookie_storage import EncryptedCookieStorage
from envparse import env

# Reading settings file
if not isfile('.env'):
    raise Exception('Need .env file')
env.read_envfile('.env')


# Database connection parameters obtained from .env
def get_dsn():
    '''DB connection string
    :return:
    '''
    return f"dbname={env.str('PG_DATABASE')} user={env.str('PG_USERNAME')} " \
           f"password={env.str('PG_PASSWORD')} host={env.str('PG_SERVER')}"


def get_sekret_key():
    '''SECRET_KEY for the session
    :return:
    '''
    return EncryptedCookieStorage(base64.urlsafe_b64decode(env.str('SECRET_KEY')))


def get_timestamp_str():
    '''TimeStamp string of the current timestamp for the base
    :return:
    '''
    return time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))




metadata = sa.MetaData()

tb_currency = sa.Table(
    'currency',
    metadata,
    sa.Column('id', sa.Integer, primary_key=True, autoincrement=True),
    sa.Column('title', sa.String(255)),
    sa.Column('code', sa.String(255)),
    sa.Column('symbol', sa.String(1)))

tb_rate = sa.Table(
    'rate',
    metadata,
    # sa.Column('id', sa.Integer, primary_key=True, autoincrement=True),
    sa.Column('from', sa.Integer),
    sa.Column('to', sa.Integer),
    sa.Column('percent', sa.Float))

tb_settings = sa.Table(
    'settings',
    metadata,
    sa.Column('id', sa.Integer, primary_key=True, autoincrement=True),
    sa.Column('wallets', sa.ARRAY(sa.Integer)),
    sa.Column('currency', sa.Integer),
    sa.Column('balance', sa.Float),
    sa.Column('fee', sa.Float))

tb_transaction = sa.Table(
    'transaction',
    metadata,
    sa.Column('id', sa.Integer, primary_key=True, autoincrement=True),
    sa.Column('sender', sa.Integer),
    sa.Column('recipient', sa.Integer),
    sa.Column('info', sa.JSON),
    sa.Column('create_at', sa.TIMESTAMP))

tb_wallet = sa.Table(
    'wallet',
    metadata,
    sa.Column('id', sa.Integer, primary_key=True, autoincrement=True),
    sa.Column('currency', sa.Integer),
    sa.Column('user', sa.Integer),
    sa.Column('account', sa.String(20)),
    sa.Column('balance', sa.Float))

tb_user = sa.Table(
    'user',
    metadata,
    sa.Column('id', sa.Integer, primary_key=True, autoincrement=True),
    sa.Column('email', sa.String(255)),
    sa.Column('password', sa.String(255)),
    sa.Column('name', sa.String(255)),
    sa.Column('surname', sa.String(255)))


async def get_currencies(engine):
    '''
    :param engine:
    :return:
    '''
    async with engine.acquire() as conn:
        currencies = []
        async for row in await conn.execute(tb_currency.select().order_by(tb_currency.c.id)):
            currencies.append({'id': row[0], 'title': row[1], 'code': row[2], 'symbol': row[3]})
        return currencies

async def get_settings(engine):
    '''
    :param engine:
    :return:
    '''
    async with engine.acquire() as conn:
        async for row in await conn.execute(tb_settings.select().order_by(sa.desc(tb_settings.c.id)).limit(1)):
            return {'id': row[0], 'wallets': row[1], 'currency': row[2], 'balance': row[3], 'fee': row[4]}

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
            rates.append({'from': row[0], 'to': row[1], 'percent': row[2]})
        return rates

async def get_user_by_email(engine, email):
    '''User existence check
    :param engine: DB connection
    :param email: user email
    :return: a list of users
    '''
    async with engine.acquire() as conn:
        async for row in conn.execute(tb_user.select().where(tb_user.c.email == email)):
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
                f'''select w.id, c.title, c.symbol, w.account, w.balance
                from wallet as w
                left join currency as c on c.id = w.currency
                where w.user = {user_id};'''):

            wallets.append({
                'id': row[0],
                'title': row[1],
                'symbol': row[2],
                'account': row[3],
                'balance': row[4],
                'description': f'{row[3]} : {row[2]} {row[4]}'
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
                f'''select w.id, c.title, c.symbol, w.account
                from wallet as w
                left join currency as c on c.id = w.currency;'''):
            wallets.append({
                'id': row[0],
                'title': row[1],
                'symbol': row[2],
                'account': row[3],
                'description': f'{row[3]} : {row[2]}'
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


# async def get_wallet_locked(engine, account):
#     '''
#     :param engine:
#     :param account:
#     :return:
#     '''
#     async with engine.acquire() as conn:
#         sql = f'''select w.locked is True
#             from wallet as w
#             where w.account = '{account}';'''
#         return await conn.scalar(sql)

# async def set_wallet_locked(engine, account, state):
#     '''
#     :param engine:
#     :param account:
#     :return:
#     '''
#     async with engine.acquire() as conn:
#         result = await conn.execute(
#             f'''update wallet as w
#             set "locked"={state}
#             where w.account = '{account}';''')
#         return result

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

# async def get_user_rules(engine, user_id):
#     '''Obtaining user rights by id
#     :param engine: DB connection
#     :param user_id: user id
#     :return: user rights list
#     '''
#     async with engine.acquire() as conn:
#         rules = []
#         join = sa.join(tb_rule, tb_user_rule, tb_rule.c.id == tb_user_rule.c.rule)
#         async for row in conn.execute(
#                 tb_rule.select().select_from(join).where(tb_user_rule.c.user == user_id)):
#             rules.append(row[1])
#         return rules
#
#
# async def get_user_info(engine, user_id):
#     '''Getting user data by id
#     :param engine: DB connection
#     :param user_id: user id
#     :return: user information
#     '''
#     async with engine.acquire() as conn:
#         async for row in conn.execute(tb_user.select().where(tb_user.c.id == user_id)):
#             return {
#                 'id': row[0],
#                 'email': row[1],
#                 'password': row[2],
#                 'name': row[3],
#                 'surname': row[4],
#                 'rules': await get_user_rules(engine=engine, user_id=user_id)
#             }
#
#
# async def get_users(engine, admin):
#     '''Retrieving user data
#     :param engine: DB connection
#     :param admin: Request data for admin user
#     :return: a list of users
#     '''
#     async with engine.acquire() as conn:
#         users = []
#         where = '' if admin else 'WHERE u.delete_at is null'
#         async for row in await conn.execute(
#                 f'''SELECT u.id, u.email, u.password, u.name, u.surname, u.delete_at,
#                 ARRAY(
#                     SELECT r.rule
#                     FROM "user_rule" as ur
#                     LEFT JOIN "rule" as r on ur.rule = r.id
#                     WHERE ur.user = u.id
#                 ) as "rules"
#                 FROM "user" as u
#                 {where}
#                 ORDER BY u.id;'''):
#             # If the data is requested not by the Admin, then we do not show the admins
#             if not admin and 'admin' in row[6]:
#                 continue
#             users.append({
#                 'id': row[0],
#                 'email': row[1],
#                 'password': row[2],
#                 'name': row[3],
#                 'surname': row[4],
#                 'delete': row[5] is not None,
#                 'rules': row[6]
#             })
#         return users
#
#
# async def get_rules(engine):
#     '''Obtaining rights data
#     :param engine: DB connection
#     :return: list of rights
#     '''
#     async with engine.acquire() as conn:
#         rules = {}
#         async for row in conn.execute(tb_rule.select()):
#             # {'admin': 0}
#             rules[row[1]] = row[0]
#         return rules
#
#
# async def set_rules_for_user(engine, user_id, data):
#     '''Setting / changing user rights
#     :param engine: DB connection
#     :param user_id: user id
#     :param data: data for setting
#     :return:
#     '''
#     rules = await get_rules(engine)
#     user_rules = await get_user_rules(engine, user_id)
#
#     for rule, rule_id in rules.items():
#         # The user already has the current role and from the form flew to True
#         # if rule in user_rules and data.get(rule, False) is True:
#
#         # The user does not have the current role and from the form flew to False
#         # if rule not in user_rules and data.get(rule, False) is False:
#
#         # The user has a role, but False has arrived from the form - delete
#         if rule in user_rules and data.get(rule, False) is False:
#             async with engine.acquire() as conn:
#                 await conn.execute(
#                     tb_user_rule.delete(None)
#                     .where(tb_user_rule.c.user == user_id)
#                     .where(tb_user_rule.c.rule == rule_id))
#
#         # The user does not have roles, but True has arrived from the form - add
#         if rule not in user_rules and data.get(rule, False) is True:
#             async with engine.acquire() as conn:
#                 await conn.execute(tb_user_rule.insert(None).values(user=user_id, rule=rule_id))
#
#
# async def set_delete_at_for_user(engine, user_id, restore=False):
#     '''Delete user by id
#     :param engine: DB connection
#     :param user_id: id of the user to be deleted
#     :return:
#     '''
#     timestamp = 'null' if restore else f"'{get_timestamp_str()}'"
#
#     async with engine.acquire() as conn:
#         await conn.execute(f'''UPDATE "user" SET delete_at={timestamp} WHERE id={user_id};''')


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

        user_id = await conn.scalar(tb_user.insert(None).values(
            email=data['email'],
            password=data['password'],
            name=data['name'],
            surname=data['surname']))

        # Create wallet for user from settings
        settings = await get_settings(engine=engine)
        for currency in settings['wallets']:

            account = ''.join(random.choice(string.digits) for _ in range(20))
            await conn.scalar(tb_wallet.insert(None).values(
                currency=currency,
                user=user_id,
                account=account,
                balance= settings['balance'] if settings['currency'] == currency else 0))
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
    VALUES('{wallet_from['account']}', '{wallet_to['account']}', '{json.dumps(info)}', '{get_timestamp_str()}');'''

    async with engine.acquire() as conn:
        await conn.execute(
            f'''BEGIN;
            {update_from}
            {update_to}
            {transaction}
            COMMIT;''')

# async def update_user(engine, data):
#     '''User data update
#     :param engine: DB connection
#     :param data: user data to update
#     :return:
#     '''
#     async with engine.acquire() as conn:
#         # Check that the email matches the current one, or that it is unique in the database
#         user = await get_user_by_email(engine=engine, email=data['email'])
#         if user is not None and int(user['id']) != int(data['id']):
#             raise Warning('A user with this email already exists')
#
#         await conn.execute(
#             sa.update(tb_user)
#             .values({
#                 'email': data['email'],
#                 'password': data['password'],
#                 'name': data['name'],
#                 'surname': data['surname']
#             })
#             .where(tb_user.c.id == int(data['id'])))
#
#         await set_rules_for_user(engine=engine, user_id=int(data['id']), data=data)
