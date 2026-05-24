require "rails_helper"

RSpec.describe Follow, type: :model do
  subject(:follow) { build(:follow) }

  describe "associations" do
    it { should belong_to(:follower).class_name("User") }
    it { should belong_to(:followed).class_name("User") }
  end

  describe "validations" do
  subject do
    create(
      :follow,
      follower: create(:user),
      followed: create(:user),
      status: :accepted
    )
  end

  it do
    should validate_uniqueness_of(:follower_id)
      .scoped_to(:followed_id)
  end
  end

  describe "custom validations" do
    it "does not allow user to follow themselves" do
      user = create(:user)

      follow = described_class.new(
        follower: user,
        followed: user
      )

      expect(follow).not_to be_valid
      expect(follow.errors[:followed_id])
        .to include("cannot follow yourself")
    end
  end

  describe "status assignment" do
    let(:follower) { create(:user) }

    context "when account is public" do
      let(:followed) { create(:user, is_private: false) }

      it "sets status to accepted" do
        follow = described_class.create!(
          follower: follower,
          followed: followed
        )

        expect(follow.status).to eq("accepted")
      end
    end

    context "when account is private" do
      let(:followed) { create(:user, is_private: true) }

      it "sets status to pending" do
        follow = described_class.create!(
          follower: follower,
          followed: followed
        )

        expect(follow.status).to eq("pending")
      end
    end
  end
end