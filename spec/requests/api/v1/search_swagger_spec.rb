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

        run_test!
      end
    end
  end
end
