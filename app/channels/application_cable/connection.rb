module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      token = request.params[:token]

      reject_unauthorized_connection unless token

      payload = Jwt::Decoder.call(token)

      user = User.find_by(id: payload["user_id"])

      reject_unauthorized_connection unless user

      user
    rescue JWT::DecodeError
      reject_unauthorized_connection
    end
  end
end