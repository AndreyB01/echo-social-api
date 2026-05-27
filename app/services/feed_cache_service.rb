class FeedCacheService
  TTL = 30.seconds

  def self.fetch(user_id:, cursor:)
    key = cache_key(user_id: user_id, cursor: cursor)

    cached = REDIS.get(key)

    return JSON.parse(cached) if cached.present?

    result = yield

    REDIS.setex(
      key,
      TTL,
      result.to_json
    )

    result
  end

  def self.cache_key(user_id:, cursor:)
    normalized_cursor = cursor.presence || "first"

    "feed:home:#{user_id}:cursor:#{normalized_cursor}"
  end

  private_class_method :cache_key
end