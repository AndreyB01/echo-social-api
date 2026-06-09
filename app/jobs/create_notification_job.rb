class CreateNotificationJob < ApplicationJob
  queue_as :default

  def perform(user:, actor:, notification_type:, notifiable:)
    return if user == actor
    return if Block.exists?(blocker: user, blocked: actor)
    return if Mute.exists?(muter: user, muted: actor)

    return if recent_notification_exists?(
      user: user,
      actor: actor,
      notification_type: notification_type,
      notifiable: notifiable
    )

    Notification.create!(
      user: user,
      actor: actor,
      notification_type: notification_type,
      notifiable: notifiable
    )
  end

  private

  def recent_notification_exists?(
    user:,
    actor:,
    notification_type:,
    notifiable:
  )
    Notification.where(
      user: user,
      actor: actor,
      notification_type: notification_type,
      notifiable: notifiable
    ).where(
      "created_at >= ?",
      24.hours.ago
    ).exists?
  end
end