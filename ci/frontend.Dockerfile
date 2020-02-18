FROM node:10.15.3-alpine

COPY ./frontend/package.json /home/node/tds/package.json
COPY ./frontend/yarn.lock /home/node/tds/yarn.lock

WORKDIR /home/node/tds

RUN yarn install

USER node
