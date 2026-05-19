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

  
  after_create_commit :broadcast_unread_count

  private

  

  def broadcast_unread_count
    UnreadNotificationsBroadcastService.call(
      user: user
    )
  end
end