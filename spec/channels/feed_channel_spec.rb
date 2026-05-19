require "rails_helper"

RSpec.describe FeedChannel, type: :channel do
  let!(:user) { create(:user) }

  before do
    stub_connection current_user: user
  end

  it "subscribes to personal feed stream" do
    subscribe

    expect(subscription)
      .to be_confirmed

    expect(subscription)
      .to have_stream_from("feed_#{user.id}")
  end
end