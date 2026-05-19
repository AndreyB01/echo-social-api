require "rails_helper"

RSpec.describe CreateNotificationJob, type: :job do
  describe "#perform" do
    let!(:user) { create(:user) }
    let!(:actor) { create(:user) }
    let!(:post) { create(:post, user: user) }
    let!(:like) { create(:like, user: actor, post: post) }

    it "creates notification" do
      expect {
        described_class.perform_now(
          user: user,
          actor: actor,
          notification_type: "like",
          notifiable: like
        )
      }.to change(Notification, :count).by(1)
    end

    it "does not notify self actions" do
      expect {
        described_class.perform_now(
          user: user,
          actor: user,
          notification_type: "like",
          notifiable: like
        )
      }.not_to change(Notification, :count)
    end
  end
end