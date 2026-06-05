require "rails_helper"

RSpec.describe ApplicationCable::Connection, type: :channel do
  let!(:user) { create(:user) }
  let(:session) { OpenStruct.new(id: 1) }

  let(:token) do
    Jwt::AccessTokenEncoder.call(user: user, session: session)
  end

  it "connects with valid token" do
    connect "/cable?token=#{token}"

    expect(connection.current_user).to eq(user)
  end

  it "rejects connection without token" do
    expect {
      connect "/cable"
    }.to have_rejected_connection
  end
end