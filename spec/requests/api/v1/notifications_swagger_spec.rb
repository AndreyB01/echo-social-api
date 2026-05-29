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
          data: [
            {
              id: 1,
              notification_type: "like",
              read: false,
              created_at: "2026-05-29T12:00:00Z",
              actor: {
                id: 2,
                username: "alice"
              }
            }
          ],
          meta: {},
          errors: []
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
        schema({
          type: :object,
          properties: {
            count: {
              type: :integer,
              example: 5
            }
          },
          required: ['count']
        })

        let!(:user) { create(:user) }

        let(:Authorization) do
          "Bearer #{Jwt::Encoder.call(user_id: user.id)}"
        end

        example "application/json", :success_response, {
          count: 5
        }

        run_test!
      end
    end
  end
end