FROM ruby:3.3.11

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  postgresql-client \
  git \
  curl

# Создаем пользователя
RUN useradd -m appuser

# Создаем директорию приложения
RUN mkdir -p /app

# Назначаем владельца
RUN chown -R appuser:appuser /app

WORKDIR /app

# Копируем Gemfile от root
COPY Gemfile Gemfile.lock ./

# Меняем владельца файлов
RUN chown appuser:appuser Gemfile Gemfile.lock

# Переключаемся на non-root user
USER appuser

# Устанавливаем gems
RUN bundle install

# Копируем проект
COPY --chown=appuser:appuser . .

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]