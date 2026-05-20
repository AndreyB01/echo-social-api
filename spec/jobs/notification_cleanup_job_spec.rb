require "rails_helper"

RSpec.describe NotificationCleanupJob, type: :job do
  describe "#perform" do
    it "deletes notifications older than 90 days" do
      old_notification = create(
        :notification,
        created_at: 91.days.ago
      )

      recent_notification = create(
        :notification,
        created_at: 10.days.ago
      )

      described_class.perform_now

      expect(
        Notification.exists?(old_notification.id)
      ).to be_falsey

      expect(
        Notification.exists?(recent_notification.id)
      ).to be_truthy
    end
  end
end