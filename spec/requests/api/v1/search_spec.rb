require "rails_helper"

RSpec.describe "Search API", type: :request do
  describe "GET /api/v1/search" do
    let!(:user) do
      create(
        :user,
        username: "rails_tester",
        display_name: "Rails Tester",
        password: "password"
      )
    end

    let!(:post) do
      create(
        :post,
        user: user,
        body: "I love Rails"
      )
    end

    let!(:hashtag) do
      create(:hashtag, name: "rails")
    end

    let(:token) do
      auth_token_for(user)
    end

    let(:headers) do
      {
        "Authorization" => "Bearer #{token}"
      }
    end

    it "returns users, posts and hashtags" do
      get "/api/v1/search",
          params: { q: "rails" },
          headers: headers

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json["data"]).to be_an(Array)
      expect(json["data"].any? { |item| item["type"] == "user" }).to be true
      expect(json["data"].any? { |item| item["type"] == "post" }).to be true
      expect(json["data"].any? { |item| item["type"] == "hashtag" }).to be true
    end
  end
end