require "rails_helper"

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  describe "associations" do
    it { should have_many(:posts).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }

    it do
      should have_many(:active_follows)
        .class_name("Follow")
        .with_foreign_key(:follower_id)
        .dependent(:destroy)
    end

    it do
      should have_many(:passive_follows)
        .class_name("Follow")
        .with_foreign_key(:followed_id)
        .dependent(:destroy)
    end
  end

  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:username) }

    it do
      should validate_length_of(:username)
        .is_at_least(3)
        .is_at_most(30)
    end
  end
end