require "swagger_helper"

RSpec.describe "Follow Requests API", type: :request do
  path "/api/v1/follow_requests" do
    get "List pending follow requests" do
      tags "Follow Requests"

      produces "application/json"

      security [ bearerAuth: [] ]

      response "200", "follow requests list" do
        let(:user) { create(:user) }
        let(:follower) { create(:user) }

        let(:Authorization) do
          "Bearer #{Jwt::Encoder.call(user_id: user.id)}"
        end

        before do
          Follow.create!(
            follower: follower,
            followed: user,
            status: :pending
          )
        end

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