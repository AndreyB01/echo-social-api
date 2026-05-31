require "swagger_helper"

RSpec.describe "Follow Requests API", type: :request do
  path "/api/v1/follow_requests" do
    get "List pending follow requests" do
      tags "Follow Requests"

      produces "application/json"

      security [ bearerAuth: [] ]

      response "200", "follow requests list" do
        schema BaseResponseSchema.call(
          data_schema: {
            type: :array,
            items: FollowRequestSchema
          }
        )

        run_test!
      end
    end
  end
end

