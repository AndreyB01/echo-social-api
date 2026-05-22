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