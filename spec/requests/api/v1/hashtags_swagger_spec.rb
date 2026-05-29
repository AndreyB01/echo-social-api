require "swagger_helper"

RSpec.describe "Hashtags API", swagger_doc: "v1/swagger.yaml", type: :request do
  path "/api/v1/hashtags/{tag}/posts" do
    get "Get posts by hashtag" do
      tags "Hashtags"

      produces "application/json"

      security [bearerAuth: []]

      parameter name: :tag,
                in: :path,
                type: :string,
                description: "Hashtag name"

      response "200", "posts found" do
        let(:user) { create(:user) }
        let(:token) { Jwt::Encoder.call(user_id: user.id) }
        let(:Authorization) { "Bearer #{token}" }

        let(:tag) { "ruby" }
        let!(:hashtag) { create(:hashtag, name: tag) }

        run_test!
      end
    end
  end
end