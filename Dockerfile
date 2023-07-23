FROM ruby:3.2

# Install main software dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs libssl-dev libjpeg62 libvips42

RUN mkdir /solidus-marketplace
WORKDIR /solidus-marketplace
COPY Gemfile /solidus-marketplace/Gemfile
# COPY Gemfile.lock /solidus-marketplace/Gemfile.lock

RUN gem install bundler:2.4.17

COPY . /solidus-marketplace
