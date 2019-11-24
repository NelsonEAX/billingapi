# -*- coding: utf-8 -*-
'''Handlers'''
import re
import json
import asyncio
from builtins import staticmethod

from aiohttp_session import get_session
from aiohttp import web

from model import create_user, create_transaction, get_user_by_email, get_user_wallets, \
    get_all_wallets, get_currencies, get_settings, get_rates, get_rate, \
    get_wallet, get_wallet_history

# Transaction test delay
SLEEP = 1


class Auth:
    '''A class containing user atorization processing methods'''

    @staticmethod
    async def signup(request):
        '''Create new user on the site
        :param request:
        :return:
        '''
        post = await request.json()
        if post['email'] is None or post['password'] is None:
            raise Warning('Invalid data')

        post['id'] = await create_user(engine=request.app['pg_engine'], data=post)

        session = await get_session(request)
        session['id'] = post['id']
        session['email'] = post['email']

        return web.json_response({
            'status': 'succes',
            'message': 'signup ok',
            'user': post
        }, status=200)

    @staticmethod
    async def signin(request):
        '''Authorization on the site
        :param request: post contains email and password fields
        :return:
        '''
        post = await request.json()
        if post['email'] is None or post['password'] is None:
            raise Warning('Invalid data')

        user = await get_user_by_email(engine=request.app['pg_engine'], email=post['email'])

        # Do not store passwords in their pure form
        # User found and passwords match and user not deleted
        if user is None or post['password'] != user['password']:
            raise Warning('Invalid username or password')

        session = await get_session(request)
        session['id'] = user['id']
        session['email'] = user['email']

        print('[Auth.signin] user', str(user))
        return web.json_response({
            'status': 'succes',
            'message': 'signin ok',
            'user': user
        }, status=200)

    @staticmethod
    async def signout(request):
        '''Clearing a client session
        :param request: post-request
        :return:
        '''
        session = await get_session(request)
        session.clear()
        return web.json_response({
            'status': 'succes',
            'message': 'signout ok'
        }, status=200)

    @staticmethod
    async def session(request):
        '''Get user data from session
        :param request: post-request
        :return: status and service message
        '''
        session = await get_session(request)
        user = {'id': session['id'], 'email': session['email']}

        print('[Auth.session] session', str(user))
        return web.json_response({
            'status': 'succes',
            'message': 'session ok',
            'user': user
        }, status=200)


class Wallet:
    '''A class containing wallet processing methods. Need user session'''

    @staticmethod
    async def user_wallets(request):
        '''Get user wallet from session.id
        :param request:
        :return:
        '''
        session = await get_session(request)
        wallets = await get_user_wallets(engine=request.app['pg_engine'], user_id=session['id'])
        return web.json_response({
            'status': 'succes',
            'message': 'user_wallets ok',
            'wallets': wallets
        }, status=200)

    @staticmethod
    async def all_wallets(request):
        '''Get all wallet
        :param request:
        :return:
        '''
        wallets = await get_all_wallets(engine=request.app['pg_engine'])
        return web.json_response({
            'status': 'succes',
            'message': 'all_wallets ok',
            'wallets': wallets
        }, status=200)


class Currency:
    '''Information data class'''

    @staticmethod
    async def currencies(request):
        '''Get all currencies without session
        :param request:
        :return:
        '''
        currencies = await get_currencies(engine=request.app['pg_engine'])
        return web.json_response({
            'status': 'succes',
            'message': 'currencies ok',
            'currencies': currencies
        }, status=200)

    @staticmethod
    async def settings(request):
        '''Get settings without session
        :param request:
        :return:
        '''
        settings = await get_settings(engine=request.app['pg_engine'])
        return web.json_response({
            'status': 'succes',
            'message': 'settings ok',
            'settings': settings
        }, status=200)

    @staticmethod
    async def rates(request):
        '''Get rates without session
        :param request:
        :return:
        '''
        rates = await get_rates(engine=request.app['pg_engine'])
        return web.json_response({
            'status': 'succes',
            'message': 'settings ok',
            'rates': rates
        }, status=200)


class Transaction:
    '''Class for working with transactions. Need user session'''

    @staticmethod
    async def history(request):
        '''Wallet income history
        :param request:
        :return:
        '''
        post = await request.json()
        if post['wallet'] is None or not re.match(r'^\d{20}$', post['wallet']):
            raise Warning('Invalid data, history not possible')

        session = await get_session(request)
        wallets = await get_user_wallets(engine=request.app['pg_engine'], user_id=session['id'])

        for wallet in wallets:
            if wallet['account'] == post['wallet']:
                history = await get_wallet_history(
                    engine=request.app['pg_engine'],
                    wallet=post['wallet'],
                    datefrom=post['datefrom'],
                    dateto=post['dateto'])
                return web.json_response({
                    'status': 'succes',
                    'message': 'history ok',
                    'history': history
                }, status=200)

        raise Warning('Invalid data, history not possible')

    @staticmethod
    async def transaction(request):
        '''Transfer from wallet to wallet
        :param request:
        :return:
        '''
        # Lock the wallet as quickly as possible for further processing
        post = await request.json()
        if post['from'] is None or not re.match(r'^\d{20}$', post['from']):
            raise Warning('Invalid data, transaction not possible')

        try:
            await request.app['semaphore'] \
                .setdefault(post['from'], asyncio.Semaphore(value=1)) \
                .acquire()

            await asyncio.sleep(SLEEP)

            # Minimal input validation
            if post['to'] is None or not re.match(r'^\d{20}$', post['to']) \
                    or post['amount'] is None or not re.match(r'^\d*[,.]?\d*$', post['amount']):
                raise Warning('Invalid data, transaction not possible')

            settings = await get_settings(engine=request.app['pg_engine'])
            amount = float(post['amount'])

            wallet_from = await get_wallet(engine=request.app['pg_engine'], account=post['from'])
            wallet_to = await get_wallet(engine=request.app['pg_engine'], account=post['to'])

            if wallet_from is None or wallet_to is None:
                raise Warning('Invalid data, transaction not possible')

            if wallet_from['user'] == wallet_to['user']:
                commission = 0
            else:
                commission = settings['fee'] * amount * 0.01

            if amount + commission > wallet_from['balance']:
                raise Warning('Insufficient funds, transaction not possible')

            rate = await get_rate(
                engine=request.app['pg_engine'], currency_from=wallet_from['currency'],
                currency_to=wallet_to['currency'])

            # Проверили, что:
            #     - кошельки существуют
            #     - получили комиссию
            #     - получили соотношение валют
            #     - проверили, что достаточно средств для перевода

            info = {
                # сумма списания
                'amount_from': amount,
                # сумма зачисления
                'amount_to': amount * rate,
                # комиссия
                'commission': commission,
                # курс конвертации валют
                'rate': rate,
                # Кошелек отправителя ДО (создаем копию, чтоб не изменялась)
                'wallet_from_before': wallet_from.copy(),
                # Кошелек получателя ДО (создаем копию, чтоб не изменялась)
                'wallet_to_before': wallet_to.copy(),
                # Кошелек отправителя ПОСЛЕ (ссылка на изменяемый объект)
                'wallet_from_after': wallet_from,
                # Кошелек получателя ПОСЛЕ (ссылка на изменяемый объект)
                'wallet_to_after': wallet_to
            }

            wallet_from['balance'] -= commission
            wallet_from['balance'] -= amount
            wallet_to['balance'] += amount * rate

            # Вся магия в одной транзакции
            await create_transaction(engine=request.app['pg_engine'],
                                     wallet_from=wallet_from, wallet_to=wallet_to, info=info)

            print(f'[Transaction.transaction] info:\n{json.dumps(info, indent=2)}')

        except Exception as exc:
            print('[Transaction.transaction] except:', exc)
        finally:
            print('[Transaction.transaction] semaphore:', request.app['semaphore'].keys())
            request.app['semaphore'] \
                .setdefault(post['from'], asyncio.Semaphore(value=1)) \
                .release()

            return web.json_response({
                'status': 'succes',
                'message': 'transaction ok'
            }, status=200)
