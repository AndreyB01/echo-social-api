class FeedChannel < ApplicationCable::Channel
  def subscribed
    stream_from "feed_#{current_user.id}"
  end
end
