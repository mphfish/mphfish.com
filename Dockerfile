ARG ALPINE_VERSION=3.11

FROM elixir:1.10.2-alpine AS builder

ARG APP_NAME
ARG APP_VSN
ARG MIX_ENV=prod
ARG SECRET_KEY_BASE
ARG HOSTNAME

ARG PHOENIX_SUBDIR=.

ENV APP_NAME=${APP_NAME} \
    APP_VSN=${APP_VSN} \
    MIX_ENV=${MIX_ENV} \
    SECRET_KEY_BASE=${SECRET_KEY_BASE} \
    HOSTNAME=${HOSTNAME}

WORKDIR /opt/app

RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache \
    nodejs \
    nodejs-npm \
    git \
    build-base && \
    mix local.rebar --force && \
    mix local.hex --force

COPY . .

RUN mix do deps.get, deps.compile, compile

RUN cd ${PHOENIX_SUBDIR}/assets && \
    npm install && \
    npm run deploy && \
    cd - && \
    mix phx.digest;

RUN \
    mkdir -p /opt/built && \
    mix distillery.release --verbose && \
    cp _build/${MIX_ENV}/rel/${APP_NAME}/releases/${APP_VSN}/${APP_NAME}.tar.gz /opt/built && \
    cd /opt/built && \
    tar -xzf ${APP_NAME}.tar.gz && \
    rm ${APP_NAME}.tar.gz

FROM alpine:${ALPINE_VERSION}

ARG APP_NAME

RUN apk update && \
    apk add --no-cache \
    bash \
    openssl-dev

ENV REPLACE_OS_VARS=true \
    APP_NAME=${APP_NAME}

WORKDIR /opt/app

COPY --from=builder /opt/built .

CMD trap 'exit' INT; /opt/app/bin/${APP_NAME} foreground
