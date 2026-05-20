# Echo API

Backend API for social network style application built with Ruby on Rails.

## Stack

- Ruby on Rails 7
- PostgreSQL
- Redis
- Sidekiq
- ActionCable
- Docker
- RSpec
- Swagger/OpenAPI (rswag)

---

# Setup

## Start application

```bash
docker compose up --build
```

## Database setup

```bash
docker compose exec web rails db:create
docker compose exec web rails db:migrate
docker compose exec web rails db:seed
```

---

# Run tests

```bash
docker compose exec web env RAILS_ENV=test bundle exec rspec
```

---

# API Documentation

Swagger/OpenAPI documentation:

```text
http://localhost:3000/api-docs
```

Swagger yaml:

```text
swagger/v1/swagger.yaml
```

Generate swagger docs:

```bash
docker compose exec web env RAILS_ENV=test bundle exec rake rswag:specs:swaggerize
```

---

# Notifications System

The application supports realtime notifications using ActionCable + WebSockets.

Supported notification types:

- like
- comment
- follow
- mention

## Notifications endpoints

```text
GET    /api/v1/notifications
PATCH  /api/v1/notifications/:id/read
PATCH  /api/v1/notifications/read_all
GET    /api/v1/notifications/unread_count
```

---

# WebSocket Connection

WebSocket endpoint:

```text
ws://localhost:3000/cable
```

Connection requires JWT token:

```text
ws://localhost:3000/cable?token=JWT_TOKEN
```

## Subscribe example

```javascript
const cable = new WebSocket(
  "ws://localhost:3000/cable?token=JWT_TOKEN"
)

cable.onopen = () => {
  cable.send(JSON.stringify({
    command: "subscribe",
    identifier: JSON.stringify({
      channel: "NotificationsChannel"
    })
  }))
}

cable.onmessage = (event) => {
  console.log(event.data)
}
```

---

# Background Jobs

Background jobs are processed with Sidekiq.

Start Sidekiq:

```bash
docker compose up sidekiq
```

## Scheduled Jobs

Notification cleanup job is configured via sidekiq-cron.

Job:

```text
NotificationCleanupJob
```

Removes old notifications older than 30 days.

Scheduler configurtion:

```text
config/sidekiq_schedule.yml
```

---

# ActionCable Authentication

ActionCable connections are authenticated using JWT token.

Authentication flow:

1. Client sends token in websocket query params
2. Token is decoded
3. Current user is identified
4. Unauthorized connections are rejected

---

# Features

- JWT authentication
- Refresh tokens
- Posts
- Comments
- Likes
- Follows
- Hashtags
- Personalized feed
- Realtime notifications
- Background jobs
- Swagger/OpenAPI docs
- Dockerized development environment