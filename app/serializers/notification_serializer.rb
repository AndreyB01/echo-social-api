class NotificationSerializer
  def self.render(notification)
    {
      id: notification.id,
      type: notification.notification_type,
      read: notification.read_at.present?,
      created_at: notification.created_at,

      actor: UserSerializer.render(notification.actor)
    }
  end

  def self.render_as_hash(notification)
    render(notification)
  end

  def self.render_collection(notifications)
    notifications.map { |notification| render(notification) }
  end
end