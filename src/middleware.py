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
    user_path = guest_path + ['/signout', '/wallets/user', '/wallets/all', '/transaction']

    session = await get_session(request)
    allowed_path = guest_path if session.get("email", None) is None else user_path

    result = f'path="{request.path}" {str(allowed_path)}'
    if request.path in allowed_path:
        print(f'[auth_middleware] allowed {result}')
        return await handler(request)

    print(f'[auth_middleware] NOT allowed {result}')
    return web.HTTPFound(request.app.router['auth'].url())


# @web.middleware
# async def db_middleware(request, handler):
#     '''Connection to the database.
#     Called for each request, therefore, creates an extra load. Replaced
#     :param request:
#     :param handler:
#     :return:
#     '''
#     print('[db_middleware] pg_engine create')
#     request.app['pg_engine'] = await create_engine(get_dsn())
#
#     response = await handler(request)
#
#     print('[db_middleware] pg_engine close')
#     request.app['pg_engine'].close()
#     await request.app['pg_engine'].wait_closed()
#
#     return response


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
        print('[try_catch_middleware] except:', exc)
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
    print('[pg_engine_ctx] pg_engine create ' + get_dsn())
    app['pg_engine'] = await create_engine(get_dsn())
    await migrate_data(app['pg_engine'])

    yield

    print('[pg_engine_ctx] pg_engine close')
    app['pg_engine'].close()
    await app['pg_engine'].wait_closed()