class CreateNotificationJob < ApplicationJob
  queue_as :default

  def perform(user:, actor:, notification_type:, notifiable:)
    return if user == actor
    return if Mute.exists?(muter: user, muted: actor)

    Notification.find_or_create_by!(
      user: user,
      actor: actor,
      notification_type: notification_type,
      notifiable: notifiable
    )
  end
end