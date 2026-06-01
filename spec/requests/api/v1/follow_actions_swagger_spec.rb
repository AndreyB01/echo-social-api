require "swagger_helper"

RSpec.describe "Follow Actions API", type: :request do
  path "/api/v1/users/{id}/follow/accept" do
    parameter name: :id,
              in: :path,
              type: :integer

    patch "Accept follow request" do
      tags "Follow Requests"
      produces "application/json"

      security [ bearerAuth: [] ]

      response "200", "request accepted" do
        let(:current_user) { create(:user, is_private: true) }
        let(:requester) { create(:user) }

        let(:Authorization) do
          "Bearer #{Jwt::Encoder.call(user_id: current_user.id)}"
        end

        let(:id) { requester.id }

        before do
          Follow.create!(
            follower: requester,
            followed: current_user,
            status: :pending
          )
        end

        run_test!
      end
    end
  end

  path "/api/v1/users/{id}/follow/reject" do
    parameter name: :id,
              in: :path,
              type: :integer

    patch "Reject follow request" do
      tags "Follow Requests"
      produces "application/json"

      security [ bearerAuth: [] ]

      response "200", "request rejected" do
        let(:current_user) { create(:user, is_private: true) }
        let(:requester) { create(:user) }

        let(:Authorization) do
          "Bearer #{Jwt::Encoder.call(user_id: current_user.id)}"
        end

        let(:id) { requester.id }

        before do
          Follow.create!(
            follower: requester,
            followed: current_user,
            status: :pending
          )
        end

        run_test!
      end
    end
  end
end