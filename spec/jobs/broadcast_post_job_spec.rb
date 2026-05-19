require "rails_helper"

RSpec.describe BroadcastPostJob, type: :job do
  describe "#perform" do
    let!(:author) { create(:user) }

    let!(:follower_1) { create(:user) }
    let!(:follower_2) { create(:user) }

    let!(:follow_1) do
      create(
        :follow,
        follower: follower_1,
        followed: author
      )
    end

    let!(:follow_2) do
      create(
        :follow,
        follower: follower_2,
        followed: author
      )
    end

    let!(:post) do
      create(:post, user: author)
    end

    it "broadcasts post to followers" do
      expect(FeedBroadcastService)
        .to receive(:call)
        .with(post: post, follower: follower_1)

      expect(FeedBroadcastService)
        .to receive(:call)
        .with(post: post, follower: follower_2)

      described_class.perform_now(post: post)
    end
  end
end
