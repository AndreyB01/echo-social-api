class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: true

  validates :user_id,
            uniqueness: { scope: :post_id }

  after_create_commit :enqueue_notification

  private

  def enqueue_notification
    CreateNotificationJob.perform_later(
      user: post.user,
      actor: user,
      notification_type: "like",
      notifiable: self
    )
  end
end