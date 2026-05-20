class Notification < ApplicationRecord
  belongs_to :user

  belongs_to :actor,
             class_name: "User"

  belongs_to :notifiable,
             polymorphic: true

  TYPES = %w[
    like
    comment
    follow
    mention
  ].freeze

  validates :notification_type,
            presence: true,
            inclusion: { in: TYPES }

  scope :unread, -> { where(read_at: nil) }

  
  
  after_create_commit :enqueue_broadcast

  private

  def enqueue_broadcast
    BroadcastNotificationJob.perform_later(self)
  end
end