class UnreadNotificationsBroadcastService
  def self.call(user:)
    NotificationsChannel.broadcast_to(
      user,
      {
        type: "notifications.unread_count",
        data: {
          count: unread_count(user)
        }
      }
    )
  end

  def self.unread_count(user)
    user.notifications
        .where(read_at: nil)
        .count
  end
end
