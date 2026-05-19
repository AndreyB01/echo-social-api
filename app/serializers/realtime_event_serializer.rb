class RealtimeEventSerializer
  def self.render(event:, data:)
    {
      event: event,
      timestamp: Time.current.iso8601,
      data: data
    }
  end
end