class BroadcastFeedJob < ApplicationJob
  queue_as :default

  def perform(post)
    post.user.followers.find_each do |follower|
      FeedBroadcastService.call(
        post: post,
        follower: follower
      )
    end
  end
end
