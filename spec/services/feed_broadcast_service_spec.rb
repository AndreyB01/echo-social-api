require "rails_helper"

RSpec.describe FeedBroadcastService do
  describe ".call" do
    let!(:author) { create(:user) }
    let!(:follower) { create(:user) }

    let!(:post) do
      create(
        :post,
        user: author
      )
    end

    it "broadcasts post into follower stream" do
      expect(ActionCable.server)
        .to receive(:broadcast)
        .with(
          "feed_#{follower.id}",
          hash_including(
            type: "new_post"
          )
        )

      described_class.call(
        post: post,
        follower: follower
      )
    end
  end
end
