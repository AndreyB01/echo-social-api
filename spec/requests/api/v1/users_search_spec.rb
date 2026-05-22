require "rails_helper"

RSpec.describe "Users Search API", type: :request do
  describe "GET /api/v1/users/search" do
    let!(:john) do
      create(:user,
             username: "john_doe",
             display_name: "John")
    end

    let!(:alice) do
      create(:user,
             username: "alice",
             display_name: "Alice")
    end

    let(:user) { create(:user) }

    let(:token) do
      Jwt::Encoder.call(user_id: user.id)
    end

    it "returns matched users" do
      get "/api/v1/users/search",
          params: { query: "john" },
          headers: {
            "Authorization" => "Bearer #{token}"
          }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json["data"].size).to eq(1)
      expect(json["data"][0]["username"]).to eq("john_doe")
    end
  end
end
