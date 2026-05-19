require "rails_helper"

RSpec.describe ApplicationCable::Connection, type: :channel do
  let!(:user) { create(:user) }

  let(:token) do
    Jwt::Encoder.call(user_id: user.id)
  end

  it "connects with valid token" do
    connect "/cable?token=#{token}"

    expect(connection.current_user)
      .to eq(user)
  end

  it "rejects connection without token" do
    expect {
      connect "/cable"
    }.to have_rejected_connection
  end
end