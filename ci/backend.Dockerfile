FROM ruby:2.6.0-slim

RUN apt-get update -y -qq
RUN apt-get install -qq -y --fix-missing \
    libpq-dev libcurl4-openssl-dev git \
    build-essential imagemagick libicu-dev
    # lsb-release gnupg

WORKDIR /usr/src/tds

COPY ./backend/Gemfile /usr/src/tds
COPY ./backend/Gemfile.lock /usr/src/tds

RUN bundle
