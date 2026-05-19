require "rails_helper"

RSpec.describe ReadNotificationService do
  describe ".call" do
    let!(:user) { create(:user) }

    let!(:notification) do
      create(
        :notification,
        user: user,
        read_at: nil
      )
    end

    it "marks notification as read" do
      described_class.call(notification: notification)

      expect(notification.reload.read_at)
        .not_to be_nil
    end

    it "broadcasts unread count update" do
      expect(UnreadNotificationsBroadcastService)
        .to receive(:call)
        .with(user: user)

      described_class.call(notification: notification)
    end
  end
end
