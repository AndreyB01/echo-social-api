require 'swagger_helper'

RSpec.describe 'Notifications API', type: :request, swagger_doc: 'v1/swagger.yaml' do
  path '/api/v1/notifications' do
    get 'List notifications' do
      tags 'Notifications'
      produces 'application/json'

      security [ bearerAuth: [] ]

      response '200', 'notifications found' do
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
        let!(:user) { create(:user) }

        let(:Authorization) do
          "Bearer #{Jwt::Encoder.call(user_id: user.id)}"
        end

        run_test!
      end
    end
  end
end