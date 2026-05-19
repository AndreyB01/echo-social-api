class ReadNotificationService
  def self.call(notification:)
    notification.update!(read_at: Time.current)

    UnreadNotificationsBroadcastService.call(
      user: notification.user
    )
  end
end
