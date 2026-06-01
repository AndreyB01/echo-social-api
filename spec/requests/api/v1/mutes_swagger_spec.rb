require "swagger_helper"

RSpec.describe "Mutes API", type: :request do
  path "/api/v1/users/{id}/mute" do
    parameter name: :id,
              in: :path,
              schema: { type: :integer }

    post "Mute user" do
      tags "Mutes"

      security [ bearerAuth: [] ]

      produces "application/json"

      response "201", "user muted" do
        schema BaseResponseSchema.call(
          data_schema: {
            type: :object,
            properties: {
              muted: { type: :boolean },
              user_id: { type: :integer }
            }
          }
        )

        let(:current_user) { create(:user) }
        let(:target_user) { create(:user) }
        let(:id) { target_user.id }
        let(:Authorization) { "Bearer #{Jwt::Encoder.call(user_id: current_user.id)}" }

        run_test!
      end
    end

    delete "Unmute user" do
      tags "Mutes"

      security [ bearerAuth: [] ]

      produces "application/json"

      response "200", "user unmuted" do
        schema BaseResponseSchema.call(
          data_schema: {
            type: :object,
            properties: {
              muted: { type: :boolean },
              user_id: { type: :integer }
            }
          }
        )

        let(:current_user) { create(:user) }
        let(:target_user) { create(:user) }

        let!(:mute) do
          Mute.create!(
            muter: current_user,
            muted: target_user
          )
        end

        let(:id) { target_user.id }
        let(:Authorization) { "Bearer #{Jwt::Encoder.call(user_id: current_user.id)}" }

        run_test!
      end
    end
  end
end