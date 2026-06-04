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
          "Bearer #{auth_token_for(user)}"
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

  path "/api/v1/follow_requests/{id}/accept" do
    parameter name: :id, in: :path, type: :integer, required: true

    post "Accept follow request" do
      tags "Follow Requests"
      produces "application/json"
      security [ bearerAuth: [] ]

      response "200", "follow request accepted" do
        let(:current_user) { create(:user) }
        let(:requester) { create(:user) }
        let(:follow) { create(:follow, follower: requester, followed: current_user, status: :pending) }
        let(:Authorization) { "Bearer #{auth_token_for(current_user)}" }
        let(:id) { follow.id }

        run_test!
      end

      response "404", "not found" do
        let(:current_user) { create(:user) }
        let(:Authorization) { "Bearer #{auth_token_for(current_user)}" }
        let(:id) { 999999 }

        run_test!
      end
    end
  end

  path "/api/v1/follow_requests/{id}/reject" do
    parameter name: :id, in: :path, type: :integer, required: true

    post "Reject follow request" do
      tags "Follow Requests"
      produces "application/json"
      security [ bearerAuth: [] ]

      response "200", "follow request rejected" do
        let(:current_user) { create(:user) }
        let(:requester) { create(:user) }
        let(:follow) { create(:follow, follower: requester, followed: current_user, status: :pending) }
        let(:Authorization) { "Bearer #{auth_token_for(current_user)}" }
        let(:id) { follow.id }

        run_test!
      end
    end
  end
end