require "rails_helper"

RSpec.describe Post, type: :model do
  subject(:post) { build(:post) }

  describe "associations" do
    it { should belong_to(:user) }

    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:post_hashtags).dependent(:destroy) }
    it { should have_many(:hashtags).through(:post_hashtags) }
  end

  describe "validations" do
    it { should validate_presence_of(:body) }

    it do
      should validate_length_of(:body)
        .is_at_most(280)
    end
  end

  describe "database columns" do
    it { should have_db_column(:likes_count) }
    it { should have_db_column(:comments_count) }
  end
end