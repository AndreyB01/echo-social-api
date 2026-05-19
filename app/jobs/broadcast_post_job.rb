class BroadcastPostJob < ApplicationJob
  queue_as :default

  def perform(post:)
    post.user.followers.find_each do |follower|
      FeedBroadcastService.call(
        user: follower,
        post: post
      )
    end
  end
end