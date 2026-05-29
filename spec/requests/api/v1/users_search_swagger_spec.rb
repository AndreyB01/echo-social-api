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
        schema BaseResponseSchema.call(
          data_schema: {
            type: :array,
            items: UserSchema
          }
        )

        let(:user) { create(:user) }

        let(:Authorization) do
          "Bearer #{Jwt::Encoder.call(user_id: user.id)}"
        end

        let(:query) { "john" }

        example "application/json", :success_response, {
          data: [
            {
              id: 1,
              username: "john_doe",
              email: "john@example.com",
              created_at: "2026-05-29T10:00:00Z"
            }
          ],
          meta: {},
          errors: []
        }

          run_test! do |response|
          body = JSON.parse(response.body)

          expect(body).to have_key("data")
          expect(body).to have_key("meta")
          expect(body).to have_key("errors")
        end

      end
    end
  end
end
