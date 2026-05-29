require "swagger_helper"

RSpec.describe "Profile API", type: :request do
  path "/api/v1/me" do
    get "Current user profile" do
      tags "Profile"

      produces "application/json"

      security [ bearerAuth: [] ]

      response "200", "profile found" do
        schema BaseResponseSchema.call(
          data_schema: ProfileSchema
        )

        let(:user) { create(:user) }

        let(:Authorization) do
          "Bearer #{Jwt::Encoder.call(user_id: user.id)}"
        end

        example "application/json", :success_response, {
          data: {
            id: 1,
            email: "john@example.com",
            username: "john_doe",
            display_name: "John Doe",
            bio: "Ruby developer"
          },
          meta: {},
          errors: []
        }

        run_test!
      end
    end
  end
end
