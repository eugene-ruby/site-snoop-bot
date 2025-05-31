FROM harbor.infra.vocabapp.ru/projects/ruby-ruby3.4-node-chrome:latest

WORKDIR /app
COPY . /app

# Установка зависимостей проекта
RUN bundle install

# CMD не прописываем, запуск через docker-compose
