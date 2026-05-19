require "rails_helper"

RSpec.describe NotificationBroadcastService do
  describe ".call" do
    let!(:user) { create(:user) }
    let!(:actor) { create(:user) }
    let!(:post) { create(:post, user: user) }

    let!(:notification) do
      create(
        :notification,
        user: user,
        actor: actor,
        notifiable: post
      )
    end

    it "broadcasts notification" do
      expect(NotificationsChannel)
        .to receive(:broadcast_to)

      described_class.call(
        notification: notification
      )
    end
  end
end