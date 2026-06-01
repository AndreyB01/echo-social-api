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
        let(:current_user) { create(:user) }
        let(:target_user) { create(:user) }

        let(:Authorization) do
          "Bearer #{Jwt::Encoder.call(user_id: current_user.id)}"
        end

        let(:id) { target_user.id }

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
        let(:current_user) { create(:user) }
        let(:target_user) { create(:user) }

        let(:Authorization) do
          "Bearer #{Jwt::Encoder.call(user_id: current_user.id)}"
        end

        let(:id) { target_user.id }

        before do
          Follow.create!(
            follower: current_user,
            followed: target_user,
            status: :accepted
          )
        end

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