require "rails_helper"

RSpec.describe LikePostService do
  describe "#call" do
    let(:user) { create(:user) }
    let(:post) { create(:post) }

    it "creates like" do
      expect {
        described_class.new(
          user:,
          post:
        ).call
      }.to change(Like, :count).by(1)
    end

    it "creates notification" do
      expect {
        described_class.new(
          user:,
          post:
        ).call
      }.to change(Notification, :count).by(1)
    end

    it "does not duplicate likes" do
      described_class.new(
        user:,
        post:
      ).call

      expect {
        described_class.new(
          user:,
          post:
        ).call
      }.not_to change(Like, :count)
    end

    it "does not notify own likes" do
      own_post = create(
        :post,
        user:
      )

          expect {
      described_class.new(
        user:,
        post:
      ).call
    }.to have_enqueued_job(CreateNotificationJob)
    end
  end
end