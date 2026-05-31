require "swagger_helper"

RSpec.describe "Follows API", type: :request do
  path "/api/v1/users/{id}/follow" do
    post "Follow user" do
      tags "Follows"

      consumes "application/json"
      produces "application/json"

      security [ bearerAuth: [] ]

      parameter name: :id,
                in: :path,
                schema: { type: :integer }

      response "201", "follow created" do
        schema BaseResponseSchema.call(
          data_schema: {
            type: :object,
            properties: {
              following: { type: :boolean },
              requested: { type: :boolean },
              status: { type: :string },
              user_id: { type: :integer }
            }
          }
        )

        run_test!
      end
    end

    delete "Unfollow user" do
      tags "Follows"

      produces "application/json"

      security [ bearerAuth: [] ]

      parameter name: :id,
                in: :path,
                schema: { type: :integer }

      response "200", "user unfollowed" do
        schema BaseResponseSchema.call(
          data_schema: {
            type: :object,
            properties: {
              following: { type: :boolean },
              user_id: { type: :integer }
            }
          }
        )

        run_test!
      end
    end
  end
end

