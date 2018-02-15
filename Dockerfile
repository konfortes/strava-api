FROM ruby:2.4-alpine

RUN apk update && apk add build-base nodejs postgresql-dev

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

LABEL maintainer="Ronen Konfortes <konfortes@gmail.com>"

CMD puma -C config/puma.rb
