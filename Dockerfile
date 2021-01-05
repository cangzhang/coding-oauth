FROM node:lts-alpine as build

ENV PORT 3000

WORKDIR /app
ENV PATH /app/node-modules/.bin:$PATH
COPY . ./
RUN yarn install --silent
RUN yarn build

FROM node:lts-alpine
COPY --from=build /app/__sapper__/build /usr/share/app/__sapper__/build
COPY --from=build /app/static /usr/share/app/static
COPY --from=build /app/package.json /usr/share/app/package.json
EXPOSE 3000

WORKDIR /usr/share/app
RUN yarn install --slient --production=true
ENV PATH /usr/share/app/node_modules/.bin:$PATH
CMD pm2-runtime start npm --name sapper -- start
