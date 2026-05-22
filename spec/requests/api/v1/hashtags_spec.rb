require "rails_helper"

RSpec.describe "Hashtags API", type: :request do
  describe "GET /api/v1/hashtags/:id/posts" do
    let(:user) do
      create(
        :user,
        username: "john"
      )
    end

    let!(:post_with_tag) do
      create(
        :post,
        user: user,
        body: "Hello #ruby"
      )
    end

    let!(:post_without_tag) do
      create(
        :post,
        user: user,
        body: "Hello world"
      )
    end

    before do
      ParsePostContentJob.perform_now(post_with_tag.id)
      ParsePostContentJob.perform_now(post_without_tag.id)
    end

    it "returns posts by hashtag" do
      get "/api/v1/hashtags/ruby/posts"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json["data"].size).to eq(1)

      expect(json["data"][0]["body"]).to include("#ruby")
    end
  end
end
