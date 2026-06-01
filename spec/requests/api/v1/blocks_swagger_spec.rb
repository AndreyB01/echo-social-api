require "swagger_helper"

RSpec.describe "Blocks API", type: :request do
  path "/api/v1/users/{id}/block" do
    parameter name: :id, in: :path, type: :integer

    post "Block user" do
      tags "Blocks"
      security [ bearerAuth: [] ]
      produces "application/json"

      response "201", "user blocked" do
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
              blocked: { type: :boolean },
              user_id: { type: :integer }
            }
          }
        )

        run_test!
      end
    end

    delete "Unblock user" do
      tags "Blocks"
      security [ bearerAuth: [] ]
      produces "application/json"

      response "200", "user unblocked" do
        let(:current_user) { create(:user) }
        let(:target_user) { create(:user) }

        before do
          Block.create!(
            blocker: current_user,
            blocked: target_user
          )
        end

        let(:Authorization) do
          "Bearer #{Jwt::Encoder.call(user_id: current_user.id)}"
        end

        let(:id) { target_user.id }

        schema BaseResponseSchema.call(
          data_schema: {
            type: :object,
            properties: {
              blocked: { type: :boolean },
              user_id: { type: :integer }
            }
          }
        )

        run_test!
      end
    end
  end
end