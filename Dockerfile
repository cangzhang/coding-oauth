FROM node:lts-alpine as build

ENV PORT 3000

WORKDIR /app
ENV PATH /app/node-modules/.bin:$PATH
COPY package.json ./
COPY yarn.lock ./
RUN yarn install --silent --prod=true --cache-folder=.yarn/
COPY . ./
RUN yarn build

FROM node:lts-alpine
COPY --from=build /app/node_modules /usr/share/app/node_modules
COPY --from=build /app/__sapper__/build /usr/share/app/__sapper__/build
COPY --from=build /app/static /usr/share/app/static
COPY --from=build /app/package.json /usr/share/app/package.json
EXPOSE 3000

WORKDIR /usr/share/app
CMD pm2 start yarn --name sapper -- start
