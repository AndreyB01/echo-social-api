require "rails_helper"

RSpec.describe Like, type: :model do
  subject(:like) { create(:like) }

  describe "associations" do
    it { should belong_to(:user) }

    it do
      should belong_to(:post)
        .counter_cache(true)
    end
  end

  describe "validations" do
    it do
      should validate_uniqueness_of(:user_id)
        .scoped_to(:post_id)
    end
  end

  describe "counter cache" do
    it "increments likes_count" do
      post = create(:post)

      expect {
        create(:like, post:)
      }.to change {
        post.reload.likes_count
      }.by(1)
    end

    it "decrements likes_count when destroyed" do
      like = create(:like)
      post = like.post

      expect {
        like.destroy
      }.to change {
        post.reload.likes_count
      }.by(-1)
    end
  end
end