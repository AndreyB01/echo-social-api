class HealthController < ApplicationController
  def index
    render json: {
      status: "ok",
      database: database_status,
      redis: redis_status,
      sidekiq: sidekiq_status
    }
  end

  private

    def database_status
    ActiveRecord::Base.connection.execute("SELECT 1")
        true
    rescue
        false
    end

  def redis_status
    Redis.new(url: ENV.fetch("REDIS_URL", "redis://redis:6379/0")).ping == "PONG"
  rescue
    false
  end

  def sidekiq_status
    Sidekiq.redis(&:ping) == "PONG"
  rescue
    false
  end
end