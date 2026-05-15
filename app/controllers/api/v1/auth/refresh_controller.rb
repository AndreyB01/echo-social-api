module Api
  module V1
    module Auth
      class RefreshController < ApplicationController
        def create
          token = params[:refresh_token]

          token_digest = Digest::SHA256.hexdigest(token)

          refresh_token = RefreshToken.active.find_by(
            token_digest: token_digest
          )

          if refresh_token.nil?
            render json: {
              error: "Invalid refresh token"
            }, status: :unauthorized

            return
          end

          user = refresh_token.user

          refresh_token.destroy!

          raw_refresh_token = SecureRandom.hex(64)

          new_refresh = user.refresh_tokens.create!(
            token_digest: Digest::SHA256.hexdigest(raw_refresh_token),
            expires_at: 30.days.from_now
          )

          access_token = Jwt::Encoder.call(user_id: user.id)

          render json: {
            access_token: access_token,
            refresh_token: raw_refresh_token,
            token_type: "Bearer"
          }, status: :ok
        end
      end
    end
  end
end