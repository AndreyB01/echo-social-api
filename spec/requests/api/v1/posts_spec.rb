require 'rails_helper'

RSpec.describe "Posts API", type: :request do
  let!(:user) { create(:user, username: "alice") }
  let!(:posts) { create_list(:post, 3, user: user) }
  let(:headers) { { "Authorization" => "Bearer #{user.create_jwt}" } }

  describe "GET /api/v1/posts" do
    before { get "/api/v1/posts", headers: headers }

    it "returns posts" do
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["data"].size).to eq(3)
      expect(json["data"].first).to include("id", "body", "created_at", "likes_count", "comments_count", "hashtags", "author")
    end

    it "returns meta info" do
      json = JSON.parse(response.body)
      expect(json["meta"]).to include("current_page", "next_page", "prev_page", "total_pages", "total_count")
    end
  end
end