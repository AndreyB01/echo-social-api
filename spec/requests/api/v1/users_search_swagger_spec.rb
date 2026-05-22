require "swagger_helper"

RSpec.describe "Users Search API", type: :request do
  path "/api/v1/users/search" do
    get "Search users" do
      tags "Users"

      produces "application/json"

      security [ bearerAuth: [] ]

      parameter name: :query,
                in: :query,
                type: :string,
                description: "Search query"

      response "200", "users found" do
        let(:user) { create(:user) }

        let(:Authorization) do
          "Bearer #{Jwt::Encoder.call(user_id: user.id)}"
        end

        let(:query) { "john" }

        run_test!
      end
    end
  end
end