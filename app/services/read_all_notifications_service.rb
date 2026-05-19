class ReadAllNotificationsService
  def self.call(user:)
    mark_as_read(user)
    broadcast_unread_count(user)
  end

  def self.mark_as_read(user)
    user.notifications
        .where(read_at: nil)
        .update_all(read_at: Time.current)
  end

  def self.broadcast_unread_count(user)
    UnreadNotificationsBroadcastService.call(
      user: user
    )
  end
end