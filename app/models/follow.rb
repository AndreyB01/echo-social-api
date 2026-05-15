class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, uniqueness: { scope: :followed_id }

  after_create :create_notification

  private

  def create_notification
    Notification.create!(
      user: followed,
      actor: follower,
      notification_type: "follow",
      notifiable: self
    )
  end
end