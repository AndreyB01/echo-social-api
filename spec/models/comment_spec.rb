require "rails_helper"

RSpec.describe Comment, type: :model do
  subject(:comment) { create(:comment) }

  describe "associations" do
    it { should belong_to(:user) }

    it do
      should belong_to(:post)
        .counter_cache(true)
    end
  end

  describe "validations" do
    it do
      should validate_presence_of(:body)
    end

    it do
      should validate_length_of(:body)
        .is_at_most(1000)
    end
  end

  describe "counter cache" do
    it "increments comments_count" do
      post = create(:post)

      expect {
        create(:comment, post:)
      }.to change {
        post.reload.comments_count
      }.by(1)
    end

    it "decrements comments_count when destroyed" do
      comment = create(:comment)
      post = comment.post

      expect {
        comment.destroy
      }.to change {
        post.reload.comments_count
      }.by(-1)
    end
  end
end