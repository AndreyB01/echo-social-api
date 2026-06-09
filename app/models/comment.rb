class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: true

  validates :body, presence: true, length: { maximum: 1000 }

  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  after_create :create_notification

  def soft_delete!
    update!(deleted_at: Time.current)
  end

  private

  def create_notification
    return if user == post.user

    CreateNotificationJob.perform_later(
      user: post.user,
      actor: user,
      notification_type: "comment",
      notifiable: self
    )
  end
end