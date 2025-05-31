# SiteSnoopBot

## Описание проекта

SiteSnoopBot — это Telegram-бот, который следит за изменениями DOM-элементов на веб-страницах по указанному пользователем атрибуту (например, `data-qa="title"`). Бот уведомляет о любых изменениях в тексте элемента.

### Ограничения

Один `chat_id` может иметь не более 10 записей в таблице `snapshots`.

Пользователь отправляет команду `/watch <url> <attribute_selector>`, чтобы начать наблюдение за элементом на веб-странице. Бот сохраняет информацию о наблюдении и периодически проверяет изменения.

### Определение изменений

Бот определяет изменения с помощью хеширования содержимого элемента (`content_hash`). Если хеш изменился, бот отправляет уведомление пользователю.

### Использование Sidekiq

Sidekiq используется для периодической проверки изменений. Воркер `SnapshotCheckAllWorker` загружает все записи и вызывает `CheckTaskWorker` для каждой из них.

## Как развернуть локально

1. Убедитесь, что у вас установлены Docker и Docker Compose.
2. Скопируйте пример файла окружения: `cp .env.example .env`
3. Запустите контейнеры: `docker-compose up --build`
4. После деплоя выполните: `whenever --update-crontab --set environment=production`

### Переменные окружения

- `TELEGRAM_API_TOKEN`: токен вашего Telegram-бота.
- `REDIS_URL`: URL для подключения к Redis.
- `DATABASE_URL`: URL для подключения к базе данных PostgreSQL.

## Как собрать BASE образ вручную

Образ большой ( ~1ГБ), поэтому не рекомендуется собирать его через GitHub Actions.

```bash
docker build -f Dockerfile.base -t harbor.infra.vocabapp.ru/projects/ruby-ruby3.4-node-chrome:latest .
docker push harbor.infra.vocabapp.ru/projects/ruby-ruby3.4-node-chrome:latest
```

## Деплой

Деплой запускается по git-тегу (например, v0.2.0) через GitHub Actions.

```bash
make deploy         # v1.0.1 → v1.0.2
make deploy-minor   # v1.0.2 → v1.1.0
make deploy-major   # v1.1.0 → v2.0.0
```

### В CI

- Подключение к серверу по SSH.
- Логин в Harbor.
- Пуш базового Docker-образа с тегом.
- Сборка приложения Docker-образа с тегом.
- Пуш приложения Docker-образа с тегом.
- Перезапуск через docker-compose в директории `~/apps/site-snoop-bot`.

### База данных и Redis

- База данных PostgreSQL и Redis находятся внутри docker-compose (если изолировано).
- Или могут быть внешними — в этом случае .env должен содержать корректные подключения.

## Команды Telegram-бота

- `/watch <url> <attribute_selector>` — начать наблюдение.
- `/list` — показать все наблюдаемые элементы.
- `/stop <id>` — (если реализовано) прекратить наблюдение.
- `/start` — стартовое сообщение.

## Примечания

- Используются библиотеки: dry-monads, sequel, sidekiq, selenium-webdriver.
- Парсинг происходит с помощью headless Chrome через Selenium.
- Пример атрибута: `data-qa="title"`.
