FROM ruby:3.4

# Установка Node.js и Chrome
RUN apt-get update -qq && apt-get install -y nodejs npm chromium-driver

# Установка зависимостей
WORKDIR /app
COPY . /app
RUN bundle install

# Установка cron
RUN apt-get update -qq && apt-get install -y cron

# CMD не прописываем, запуск через docker-compose
