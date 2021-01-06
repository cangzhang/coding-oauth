import sirv from 'sirv';
import polka from 'polka';
import compression from 'compression';
import * as sapper from '@sapper/server';
import * as Sentry from '@sentry/node';

const { PORT, NODE_ENV, SENTRY_DSN } = process.env;
const dev = NODE_ENV === 'development';
const app = polka();

if (SENTRY_DSN) {
  Sentry.init({
    dsn: SENTRY_DSN,
    integrations: [
      // enable HTTP calls tracing
      new Sentry.Integrations.Http({ tracing: true }),
      // enable Express.js middleware tracing
      new Tracing.Integrations.Express({
        // to trace all requests to the default router
        app,
        // alternatively, you can specify the routes you want to trace:
        // router: someRouter,
      }),
    ],

    // We recommend adjusting this value in production, or using tracesSampler
    // for finer control
    tracesSampleRate: 1.0,
  });
}

const noopMiddleware = (req, res, next) => {
  next();
};

app // You can also use Express
  .use(
    SENTRY_DSN ? Sentry.Handlers.requestHandler() : noopMiddleware,
    compression({ threshold: 0 }),
    sirv('static', { dev }),
    SENTRY_DSN ? Sentry.Handlers.errorHandler() : noopMiddleware,
    sapper.middleware(),
  )
  .listen(PORT, (err) => {
    if (err) console.log('error', err);
  });
