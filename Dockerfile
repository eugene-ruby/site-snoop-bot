FROM ruby:3.4

# Установка Node.js и Chrome
RUN apt-get update -qq && apt-get install -y nodejs npm chromium-driver

# Установка зависимостей
WORKDIR /app
COPY . /app
RUN bundle install

# CMD не прописываем, запуск через docker-compose
