require 'swagger_helper'

RSpec.describe 'Notifications API',
               type: :request,
               swagger_doc: 'v1/swagger.yaml' do
  path '/api/v1/notifications' do
    get 'List notifications' do
      tags 'Notifications'

      produces 'application/json'

      security [ bearerAuth: [] ]

      response '200', 'notifications found' do
        schema BaseResponseSchema.call(
          data_schema: {
            type: :array,
            items: NotificationSchema
          }
        )

        let!(:user) { create(:user) }
        let!(:actor) { create(:user) }
        let!(:post) { create(:post, user: user) }

        let!(:notification) do
          create(
            :notification,
            user: user,
            actor: actor,
            notification_type: "like",
            notifiable: post
          )
        end

        let(:Authorization) do
          "Bearer #{Jwt::Encoder.call(user_id: user.id)}"
        end

        example "application/json", :success_response, {
          success: true,
          data: [
            {
              id: 1,
              type: "like",
              read: false,
              created_at: "2026-05-29T12:00:00Z",
              actor: {
                id: 2,
                username: "alice"
              }
            }
          ],
          meta: {
            next_cursor: nil,
            limit: 20,
            has_next: false
          }
        }

        run_test!
      end
    end
  end

  path '/api/v1/notifications/unread_count' do
    get 'Unread notifications count' do
      tags 'Notifications'

      produces 'application/json'

      security [ bearerAuth: [] ]

      response '200', 'count returned' do
        schema BaseResponseSchema.call(
          data_schema: {
            type: :object,
            properties: {
              unread_count: {
                type: :integer
              }
            },
            required: ['unread_count']
          }
        )

        let!(:user) { create(:user) }

        let(:Authorization) do
          "Bearer #{Jwt::Encoder.call(user_id: user.id)}"
        end

        example "application/json", :success_response, {
          success: true,
          data: {
            unread_count: 5
          }
        }

        run_test!
      end
    end
  end
end