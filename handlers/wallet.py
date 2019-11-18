# -*- coding: utf-8 -*-
'''Wallet page module'''
import re
from builtins import staticmethod

from aiohttp_session import get_session
from aiohttp import web

# pylint: disable=import-error
from model import *
# pylint: enable=import-error


class Wallet:

    @staticmethod
    async def user_wallets(request):
        '''Get user wallet from session.id
        :param request:
        :return:
        '''
        print('[Wallet.user_wallets]')
        session = await get_session(request)
        wallets = await get_user_wallets(engine=request.app['pg_engine'], user_id=session['id'])
        return web.json_response({'status': 'succes', 'message': 'user_wallets ok', 'wallets': wallets}, status=200)

    @staticmethod
    async def all_wallets(request):
        '''Get user wallet from session.id
        :param request:
        :return:
        '''
        print('[Wallet.all_wallets]')
        wallets = await get_all_wallets(engine=request.app['pg_engine'])
        return web.json_response({'status': 'succes', 'message': 'all_wallets ok', 'wallets': wallets}, status=200)


class Currency:

    @staticmethod
    async def currencies(request):
        '''Get all currencies without session
        :param request:
        :return:
        '''
        print('[Currency.currencies]')
        currencies = await get_currencies(engine=request.app['pg_engine'])
        return web.json_response({'status': 'succes', 'message': 'currencies ok', 'currencies': currencies}, status=200)

    @staticmethod
    async def settings(request):
        '''Get settings
        :param request:
        :return:
        '''
        print('[Currency.settings]')
        settings = await get_settings(engine=request.app['pg_engine'])
        return web.json_response({'status': 'succes', 'message': 'settings ok', 'settings': settings}, status=200)


class Transaction:

    @staticmethod
    async def transaction(request):
        '''Get all currencies without session
        :param request:
        :return:
        '''
        print('[Transaction.transaction] start')

        post = await request.json()

        # Минимальная проверка входных данных
        if post['from'] is None or not re.match(r'^\d{20}$', post['from']) \
                or post['to'] is None or not re.match(r'^\d{20}$', post['to']) \
                or post['amount'] is None or not re.match(r'^\d*[,.]?\d*$', post['amount']):
            raise Warning('Invalid data, transaction not possible')

        # session = await get_session(request) # TODO: middleware
        # user_wallets = await get_user_wallets(engine=request.app['pg_engine'], user_id=session['id'])
        # all_wallets = await get_all_wallets(engine=request.app['pg_engine'])
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

        print(f'[Transaction.transaction] before recording. commission = {commission}, '
              f'wallet_from = {wallet_from}, wallet_to = {wallet_to}')

        # Проверили, что:
        #     - кошельки существуют
        #     - получили комиссию
        #     - проверили, что достаточно средств для перевода




        return web.json_response({'status': 'succes', 'message': 'transaction ok'}, status=200)