FROM ruby:3.2

# Install main software dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs libssl-dev libjpeg62 libvips42

RUN mkdir /community-commerce
WORKDIR /community-commerce
COPY Gemfile /community-commerce/Gemfile
COPY Gemfile.lock /community-commerce/Gemfile.lock

RUN gem install bundler:2.4.17

COPY . /community-commerce
