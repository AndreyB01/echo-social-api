class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: true

  validates :body, presence: true, length: { maximum: 1000 }

  after_create :create_notification

  private

  def create_notification
    return if user == post.user

    Notification.create!(
      user: post.user,
      actor: user,
      notification_type: "comment",
      notifiable: self
    )
  end
end