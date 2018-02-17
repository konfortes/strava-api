FROM ruby:2.4-alpine

RUN apk update && apk add build-base nodejs postgresql-dev

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

RUN apk add --no-cache openssl
ENV DOCKERIZE_VERSION v0.6.0
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz
    
COPY . .

LABEL maintainer="Ronen Konfortes <konfortes@gmail.com>"

CMD puma -C config/puma.rb
