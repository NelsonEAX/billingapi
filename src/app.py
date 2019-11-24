# -*- coding: utf-8 -*-
'''Application start module. Point of entry.
Initializing an application
Setting up a session
Setting up templates, adding routes
'''

from aiohttp_session import session_middleware
from aiohttp import web
import aiohttp_cors

from handlers import Auth, Wallet, Currency, Transaction
from model import get_sekret_key
from middleware import pg_engine_ctx, try_except_middleware,auth_middleware


# initialize the application
app = web.Application(middlewares=[
    session_middleware(get_sekret_key()),
    try_except_middleware,
    # db_middleware, # migrate to app.cleanup_ctx
    auth_middleware,
])

# app.on_startup.append(create_pg_engine)
# app.on_cleanup.append(dispose_pg_engine)



# async def start_background_tasks(app):
#     app['queue_transaction'] = asyncio.Queue()
#     app['complete_transaction'] = asyncio.create_task(transaction.prod(app))
#
#
# async def cleanup_background_tasks(app):
#     await app['queue_transaction'].join()
#     app['complete_transaction'].cancel()
#     await app['complete_transaction']
#
# app.on_startup.append(start_background_tasks)
# app.on_cleanup.append(cleanup_background_tasks)
app['semaphore'] = dict()
app.cleanup_ctx.append(pg_engine_ctx)

# allowed
app.router.add_post('/signin', Auth.signin)
app.router.add_post('/signup', Auth.signup)
app.router.add_post('/session', Auth.session)
app.router.add_post('/settings', Currency.settings)
app.router.add_post('/currencies', Currency.currencies)
app.router.add_post('/rates', Currency.rates)

# NOT allowed
app.router.add_post('/signout', Auth.signout)
app.router.add_post('/wallets/user', Wallet.user_wallets)
app.router.add_post('/wallets/all', Wallet.all_wallets)
app.router.add_post('/transaction', Transaction.coro)

# app.router.add_view('/', view_index)
# app.router.add_view('/index', view_index)
# app.router.add_view('/auth', view_auth, name='auth')
# app.router.add_view('/part2', view_part2)
# app.router.add_get('/part2/json/{part:[0-4]}', view_part2_json, name='json_part')
# app.router.add_get('/part2/json2', view_part2)

# `aiohttp_cors.setup` returns `aiohttp_cors.CorsConfig` instance.
# The `cors` instance will store CORS configuration for the application.
cors = aiohttp_cors.setup(app, defaults={
    "*": aiohttp_cors.ResourceOptions(
            allow_credentials=True,
            expose_headers="*",
            allow_headers="*",
        )
})

# Configure CORS on all routes.
for route in list(app.router.routes()):
    cors.add(route)

# ssl_context = ssl.create_default_context(ssl.Purpose.SERVER_AUTH)
# ssl_context.load_cert_chain('domain_srv.crt', 'domain_srv.key')

web.run_app(app) #, ssl_context=ssl_context)
