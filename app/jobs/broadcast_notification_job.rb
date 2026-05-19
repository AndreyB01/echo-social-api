class BroadcastNotificationJob < ApplicationJob
  queue_as :default

  def perform(notification)
    NotificationBroadcastService.call(
      notification: notification
    )

    UnreadNotificationsBroadcastService.call(
      user: notification.user
    )
  end
end