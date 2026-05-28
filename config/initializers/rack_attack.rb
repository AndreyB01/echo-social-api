class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  ###
  # Global API throttling
  ###
  throttle("req/ip", limit: 300, period: 5.minutes) do |req|
    req.ip
  end

  ###
  # Login throttling
  ###
  throttle("logins/ip", limit: 5, period: 20.seconds) do |req|
    if req.path == "/api/v1/auth/login" && req.post?
      req.ip
    end
  end

  ###
  # Posts creation throttling
  ###
  throttle("posts/ip", limit: 10, period: 1.minute) do |req|
    if req.path == "/api/v1/posts" && req.post?
      req.ip
    end
  end

  ###
  # Follow throttling
  ###
  throttle("follows/ip", limit: 20, period: 1.minute) do |req|
    if req.path.match?(%r{^/api/v1/users/\d+/follow$}) &&
       (req.post? || req.delete?)
      req.ip
    end
  end

  ###
  # Likes throttling
  ###
  throttle("likes/ip", limit: 30, period: 1.minute) do |req|
    if req.path.match?(%r{^/api/v1/posts/\d+/like$}) &&
       (req.post? || req.delete?)
      req.ip
    end
  end

  ###
  # Custom throttled response
  ###
  self.throttled_responder = lambda do |_request|
    [
      429,
      { "Content-Type" => "application/json" },
      [{ error: "Rate limit exceeded" }.to_json]
    ]
  end
end