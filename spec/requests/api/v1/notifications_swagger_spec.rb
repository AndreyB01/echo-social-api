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
          },
          meta_schema: PaginationMetaSchema
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
          "Bearer #{auth_token_for(user)}"
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

  path '/api/v1/notifications/{id}/read' do
    parameter name: :id,
              in: :path,
              type: :integer,
              required: true

    patch 'Mark notification as read' do
      tags 'Notifications'

      produces 'application/json'

      security [ bearerAuth: [] ]

      response '200', 'notification marked as read' do
        let(:user) { create(:user) }
        let(:actor) { create(:user) }
        let(:post) { create(:post, user: actor) }

        let(:notification) do
          create(
            :notification,
            user: user,
            actor: actor,
            notification_type: 'like',
            notifiable: post
          )
        end

        let(:id) { notification.id }

        let(:Authorization) do
          "Bearer #{auth_token_for(user)}"
        end

        run_test!
      end
    end
  end

  path '/api/v1/notifications/read_all' do
    patch 'Mark all notifications as read' do
      tags 'Notifications'

      produces 'application/json'

      security [ bearerAuth: [] ]

      response '200', 'all notifications marked as read' do
        let(:user) { create(:user) }

        let(:Authorization) do
          "Bearer #{auth_token_for(user)}"
        end

        run_test!
      end
    end
  end
end