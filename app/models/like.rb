class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :user_id,
            uniqueness: { scope: :post_id }

  after_create_commit :create_notification

  private

  def create_notification
    return if post.user == user

    Notification.create!(
      user: post.user,
      actor: user,
      notification_type: "like",
      notifiable: self
    )
  end
end