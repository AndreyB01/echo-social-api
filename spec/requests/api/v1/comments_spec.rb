require 'rails_helper'

RSpec.describe "Comments API", type: :request do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:comments) { create_list(:comment, 3, post: post, user: user) }
  let(:headers) { { "Authorization" => "Bearer #{user.create_jwt}" } }

  describe "GET /api/v1/posts/:post_id/comments" do
    before { get "/api/v1/posts/#{post.id}/comments", headers: headers }

    it "returns comments" do
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["data"].size).to eq(3)
      expect(json["data"].first).to include("id", "body", "created_at", "author")
    end
  end
end