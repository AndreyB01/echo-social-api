class NotificationCleanupJob < ApplicationJob
  queue_as :default

  def perform
    Notification.where(
      "created_at < ?",
      90.days.ago
    ).delete_all
  end
end