require 'rails_helper'

RSpec.describe "Posts API", type: :request do
  let!(:user) { create(:user) }
  let!(:posts) { create_list(:post, 3, user: user) }

  let(:token) do
    auth_token_for(user)
  end

  let(:headers) do
    {
      "Authorization" => "Bearer #{token}"
    }
  end

  describe "GET /api/v1/posts" do
    it "returns posts" do
      get "/api/v1/posts", headers: headers

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json["data"].size).to eq(3)

      expect(json["data"].first)
        .to include(
          "id",
          "body",
          "created_at",
          "likes_count",
          "comments_count",
          "hashtags",
          "author"
        )
    end

    it "returns meta info" do
      get "/api/v1/posts", headers: headers

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json["meta"])
        .to include(
          "next_cursor",
          "limit",
          "has_next"
        )
    end
  end
end