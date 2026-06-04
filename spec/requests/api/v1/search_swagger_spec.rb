require "swagger_helper"

RSpec.describe "Search API", type: :request do
  path "/api/v1/search" do
    get "Global search" do
      tags "Search"

      produces "application/json"

      security [bearerAuth: []]

      parameter name: :query,
                in: :query,
                type: :string,
                description: "Search query"

      parameter name: :cursor,
                in: :query,
                type: :string,
                required: false,
                description: "Pagination cursor"

      parameter name: :limit,
                in: :query,
                type: :integer,
                required: false,
                description: "Items per page (default 20, max 50)"

      response "200", "search results" do
        let(:user) do
          create(:user,
                 username: "railsdev",
                 display_name: "Rails Dev")
        end

        let!(:post) do
          create(:post,
                 user: user,
                 body: "Rails is awesome")
        end

        let!(:hashtag) do
          create(:hashtag, name: "rails")
        end

        let(:Authorization) do
          token = auth_token_for(user)
          "Bearer #{token}"
        end

        let(:query) { "rails" }

        schema BaseResponseSchema.call(
          data_schema: {
            type: :array,
            items: {
              type: :object,
              properties: {
                type: { type: :string, enum: ["user", "post", "hashtag"] },
                id: { type: :integer },
                attributes: { type: :object }
              }
            }
          },
          meta_schema: PaginationMetaSchema
        )

        run_test!
      end
    end
  end
end