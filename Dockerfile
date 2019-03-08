FROM alpine:3.8 as build-env

RUN apk update && apk upgrade &&\
    apk add --no-cache bash git &&\
	mkdir downloads

ARG TAG_VERSION=master
RUN git clone -b ${TAG_VERSION} --single-branch https://github.com/OpenBankingUK/reference-mock-server.git /downloads/reference-mock-server

WORKDIR /downloads/reference-mock-server
COPY server.env ./
RUN cp server.env .env

FROM node:8.4-alpine

RUN apk update && apk upgrade
WORKDIR /home/node/app
RUN chown -R node:node /home/node/app

COPY --from=build-env /downloads .

WORKDIR /home/node/app/reference-mock-server
RUN chown -R node:node /home/node/app/reference-mock-server
USER node:node
RUN npm install

EXPOSE 8001
CMD ["npm", "run", "foreman"]