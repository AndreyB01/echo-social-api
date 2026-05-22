require "swagger_helper"

RSpec.describe "Hashtags API", type: :request do
  path "/api/v1/hashtags/{id}/posts" do
    get "Get posts by hashtag" do
      tags "Hashtags"

      produces "application/json"

      parameter name: :id,
                in: :path,
                type: :string,
                description: "Hashtag name"

      response "200", "posts found" do
        let(:id) { "ruby" }

        run_test!
      end
    end
  end
end