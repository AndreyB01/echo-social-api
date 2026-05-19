class NotificationBroadcastService
  def self.call(notification:)
    NotificationsChannel.broadcast_to(
      notification.user,
      payload(notification)
    )
  end

  def self.payload(notification)
    RealtimeEventSerializer.render(
      event: "notification.created",
      data: NotificationSerializer.render(notification)
    )
  end
end