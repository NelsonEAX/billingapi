# -*- coding: utf-8 -*-
'''Auth page module'''
from builtins import staticmethod

from aiohttp_session import get_session
from aiohttp import web

# pylint: disable=import-error
from model import *
# pylint: enable=import-error

class Auth:

    def __init__(self):
        ''''''
        print('[Auth.__init__]')
        pass

    @staticmethod
    async def signup(request):
        '''Create new user on the site
        :param request:
        :return:
        '''
        print('[Auth.signup]')

        post = await request.json()
        if post['email'] is None or post['password'] is None:
            raise Warning('Invalid data')

        post['id'] = await create_user(engine=request.app['pg_engine'], data=post)

        session = await get_session(request)
        session['id'] = post['id']
        session['email'] = post['email']

        return web.json_response({'status': 'succes', 'message': 'signup ok', 'user': post}, status=200)

    @staticmethod
    async def signin(request):
        '''Authorization on the site
        :param request: post contains email and password fields
        :return:
        '''
        print('[Auth.signin]')
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
        return web.json_response({'status': 'succes', 'message': 'signin ok', 'user': user}, status=200)

    @staticmethod
    async def signout(request):
        '''Clearing a client session
        :param request: post-request
        :return:
        '''
        print('[Auth.signout]')
        session = await get_session(request)
        session.clear()
        return web.json_response({'status': 'succes', 'message': 'signout ok'}, status=200)

    @staticmethod
    async def session(request):
        '''Get user data from session
        :param request: post-request
        :return: status and service message
        '''
        print('[Auth.session]')
        session = await get_session(request)
        user = {'id': session['id'], 'email': session['email']}

        print('[Auth.session] session', str(user))
        return web.json_response({'status': 'succes', 'message': 'session ok', 'user': user}, status=200)
