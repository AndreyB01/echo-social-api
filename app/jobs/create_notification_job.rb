class CreateNotificationJob < ApplicationJob
  queue_as :default

  def perform(user:, actor:, notification_type:, notifiable:)
    return if user == actor

    notification = Notification.create!(
      user: user,
      actor: actor,
      notification_type: notification_type,
      notifiable: notifiable
    )

    NotificationBroadcastService.call(
      notification: notification
    )
  end
end