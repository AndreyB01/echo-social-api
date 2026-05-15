class PostMention < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :post_id,
            uniqueness: { scope: :user_id }

  after_create :create_notification

  private

  def create_notification
    Notification.create!(
      user: user,
      actor: post.user,
      notification_type: "mention",
      notifiable: self
    )
  end
end