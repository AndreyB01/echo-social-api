require "rails_helper"

RSpec.describe FeedBroadcastService do
  describe ".call" do
    let!(:user) { create(:user) }
    let!(:author) { create(:user) }

    let!(:post) do
      create(:post, user: author)
    end

    it "broadcasts post into follower stream" do
      expect(ActionCable.server)
        .to receive(:broadcast)
        .with(
          "feed:#{user.to_gid_param}",
          hash_including(
            event: "feed.post_created"
          )
        )

      described_class.call(
        user: user,
        post: post
      )
    end
  end
end