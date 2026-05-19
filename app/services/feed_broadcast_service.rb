class FeedBroadcastService
  def self.call(user:, post:)
    FeedChannel.broadcast_to(
      user,
      payload(post)
    )
  end

  def self.payload(post)
    RealtimeEventSerializer.render(
      event: "feed.post_created",
      data: PostSerializer.render(post)
    )
  end
end