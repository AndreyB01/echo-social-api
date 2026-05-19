require 'rails_helper'

RSpec.describe "Notifications API", type: :request do
  let!(:user) { create(:user) }
  let!(:actor) { create(:user) }
  let!(:post) { create(:post, user: user) }

  let!(:like) do
    create(
      :like,
      user: actor,
      post: post
    )
  end

  let!(:notification) do
    create(
      :notification,
      user: user,
      actor: actor,
      notification_type: "like",
      notifiable: like
    )
  end

  let(:token) do
    Jwt::Encoder.call(user_id: user.id)
  end

  let(:headers) do
    {
      "Authorization" => "Bearer #{token}"
    }
  end

  describe "GET /api/v1/notifications" do
    before do
      get "/api/v1/notifications",
          headers: headers
    end

    it "returns notifications" do
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json["data"].first)
        .to include(
          "id",
          "type",
          "read",
          "created_at",
          "actor"
        )
    end
  end
end