class FeedBroadcastService
  def self.call(post:, follower:)
    ActionCable.server.broadcast(
      "feed_#{follower.id}",
      payload(post)
    )
  end

  def self.payload(post)
    {
      type: "new_post",
      data: PostSerializer.render(post)
    }
  end
end
