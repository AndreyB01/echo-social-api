require "swagger_helper"

RSpec.describe "Feed API", type: :request do
  path "/api/v1/feed" do
    get "Home feed" do
      tags "Feed"
      produces "application/json"
      security [ bearerAuth: [] ]
      description "Posts from followed users (including own posts). Cursor pagination."

      parameter name: :cursor, in: :query, type: :string, required: false, description: "Pagination cursor"
      parameter name: :limit, in: :query, type: :integer, required: false, description: "Items per page (default 20, max 50)"

      response "200", "feed loaded" do
        let(:user) { create(:user) }
        let(:Authorization) { "Bearer #{Jwt::Encoder.call(user_id: user.id)}" }

        schema type: :object,
               properties: {
                 items: { type: :array, items: PostSchema },
                 next_cursor: { type: :string, nullable: true }
               }

        run_test!
      end
    end
  end

  path "/api/v1/feed/global" do
    get "Global feed" do
      tags "Feed"

      produces "application/json"

      response "200", "feed loaded" do
        let!(:user) { create(:user) }

        run_test!
      end
    end
  end
end