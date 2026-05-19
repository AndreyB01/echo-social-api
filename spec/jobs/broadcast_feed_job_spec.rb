require "rails_helper"

RSpec.describe BroadcastFeedJob, type: :job do
  describe "#perform" do
    let!(:author) { create(:user) }

    let!(:follower1) { create(:user) }
    let!(:follower2) { create(:user) }

    let!(:post) do
      create(
        :post,
        user: author
      )
    end

    before do
      create(
        :follow,
        follower: follower1,
        followed: author
      )

      create(
        :follow,
        follower: follower2,
        followed: author
      )
    end

    it "broadcasts post to all followers" do
      expect(FeedBroadcastService)
        .to receive(:call)
        .twice

      described_class.perform_now(post)
    end
  end
end
