# -*- coding: utf-8 -*-
'''The file contains functions for preprocessing requests'''

from aiohttp_session import get_session
from aiopg.sa import create_engine
from aiohttp import web

from model import get_dsn, migrate_data


@web.middleware
async def auth_middleware(request, handler):
    '''Upon transition, checks that the request the user is authorized
    :param request:
    :param handler:
    :return:
    '''
    guest_path = ['/signin', '/signup', '/session', '/settings', '/currencies', '/rates']
    user_path = guest_path + [
        '/signout', '/wallets/user', '/wallets/all', '/transaction', '/history']

    session = await get_session(request)
    allowed_path = guest_path if session.get("email", None) is None else user_path

    post = await request.json()
    result = f'path="{request.path}" post="{post}" {str(allowed_path)}'
    if request.path in allowed_path:
        print(f'[Middleware.Auth] allowed {result}')
        return await handler(request)

    print(f'[Middleware.Auth] NOT allowed {result}')
    return web.HTTPFound(request.app.router['auth'].url())


@web.middleware
async def try_except_middleware(request, handler):
    '''Request try catch, response 500
    :param request:
    :param handler:
    :return:
    '''
    try:
        return await handler(request)
    except Exception as exc:
        print('[Middleware.TryException] except:', exc)
        return web.json_response({
            'status': 'error',
            'message': str(exc)
        }, status=(401 if type(exc).__name__ == 'Warning' else 500))


async def pg_engine_ctx(app):
    '''Initializing the application and adding it to the context using app.cleanup_ctx.append ()
    Connects at application startup and closes the connection upon exit
    https://aiohttp.readthedocs.io/en/stable/web_advanced.html#cleanup-context
    :param app:
    :return:
    '''
    print('[CTX.Engine] create ' + get_dsn())
    app['pg_engine'] = await create_engine(get_dsn())
    await migrate_data(app['pg_engine'])

    yield

    print('[CTX.Engine] close')
    app['pg_engine'].close()
    await app['pg_engine'].wait_closed()
