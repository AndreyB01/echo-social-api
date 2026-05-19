class NotificationBroadcastService
  def self.call(notification:)
    NotificationsChannel.broadcast_to(
      notification.user,
      payload(notification)
    )
  end

  def self.payload(notification)
    {
      type: "notification.created",
      data: NotificationSerializer.render_as_hash(notification)
    }
  end
end
