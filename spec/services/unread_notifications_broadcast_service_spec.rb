require "rails_helper"

RSpec.describe UnreadNotificationsBroadcastService do
  describe ".call" do
    let!(:user) { create(:user) }

    before do
      create_list(
        :notification,
        3,
        user: user,
        read_at: nil
      )
    end

    it "broadcasts unread notifications count" do
      expect(NotificationsChannel)
        .to receive(:broadcast_to)
        .with(
          user,
          hash_including(
            event: "notifications.unread_count",
            data: {
                count: 3
            },
            timestamp: anything
            )
        )

      described_class.call(user: user)
    end
  end
end