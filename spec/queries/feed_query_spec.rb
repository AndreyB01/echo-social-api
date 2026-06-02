require "rails_helper"

RSpec.describe FeedQuery do
  describe "#call" do
    let!(:user) { create(:user) }

    let!(:followed_user) do
      create(:user)
    end

    let!(:unfollowed_user) do
      create(
        :user,
        is_private: true
      )
    end

    let!(:follow) do
      create(
        :follow,
        follower: user,
        followed: followed_user
      )
    end

    let!(:own_post) do
      create(
        :post,
        user: user
      )
    end

    let!(:followed_post) do
      create(
        :post,
        user: followed_user
      )
    end

    let!(:unfollowed_post) do
      create(
        :post,
        user: unfollowed_user
      )
    end

    it "includes own posts" do
      result = described_class.new(user: user).call

      expect(result[:records]).to include(own_post)
    end

    it "includes followed users posts" do
      result = described_class.new(user: user).call

      expect(result[:records]).to include(followed_post)
    end

    it "does not include unfollowed users posts" do
      result = described_class.new(user: user).call

      expect(result[:records]).not_to include(unfollowed_post)
    end

    it "orders posts by newest first" do
      result = described_class.new(user: user).call

      expect(result[:records].first.created_at)
        .to be >= result[:records].last.created_at
    end
  end
end