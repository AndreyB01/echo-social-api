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

  after_create_commit :broadcast_notification

  private

  def broadcast_notification
    NotificationsChannel.broadcast_to(
      user,
      {
        id: id,
        type: notification_type,
        read: read_at.present?,
        created_at: created_at,
        actor: {
          id: actor.id,
          username: actor.username,
          display_name: actor.display_name
        }
      }
    )
  end
end