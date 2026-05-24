require "swagger_helper"

RSpec.describe "Hashtags API", swagger_doc: "v1/swagger.yaml", type: :request do
  path "/api/v1/hashtags/{id}/posts" do
    get "Get posts by hashtag" do
      tags "Hashtags"

      produces "application/json"

      security [bearerAuth: []]

      parameter name: :id,
                in: :path,
                type: :string,
                description: "Hashtag name"

      response "200", "posts found" do
        let(:user) { create(:user) }
        let(:token) { Jwt::Encoder.call(user_id: user.id) }
        let(:Authorization) { "Bearer #{token}" }

        let(:id) { "ruby" }
        let!(:hashtag) { create(:hashtag, name: id) }

        run_test!
      end
    end
  end
end