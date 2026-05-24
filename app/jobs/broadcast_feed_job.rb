class BroadcastFeedJob < ApplicationJob
  queue_as :default

  def perform(post)
    followers =
      post.user.passive_follows
          .accepted
          .includes(:follower)

    followers.each do |follow|
      FeedBroadcastService.call(
        user: follow.follower,
        post: post
      )
    end
  end
end