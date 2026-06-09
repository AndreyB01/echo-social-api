class NotifyMentionsJob < ApplicationJob
  queue_as :default

  def perform(post_id, user_id)
    post = Post.find_by(id: post_id)
    user = User.find_by(id: user_id)

    return unless post && user

    Notification.create!(
      user: user,
      actor: post.user,
      notification_type: "mention",
      notifiable: post
    )
    
  end
end