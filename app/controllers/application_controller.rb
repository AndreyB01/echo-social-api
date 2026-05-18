class ApplicationController < ActionController::API
  attr_reader :current_user

  private

  def authenticate_user!
  header = request.headers["Authorization"]

  return unauthorized_response unless header

  token = header.split(" ").last

  begin
    decoded_token = Jwt::Decoder.call(token)

    @current_user = User.find(decoded_token["user_id"])
  rescue JWT::DecodeError,
         ActiveRecord::RecordNotFound
    return unauthorized_response
  end
end

  def unauthorized_response
    render json: {
      error: "Unauthorized"
    }, status: :unauthorized
  end

  def authorize(record, query)
  policy = policy_for(record)

  unless policy.public_send(query)
    forbidden_response
  end
end

def policy_for(record)
  "#{record.class}Policy".constantize.new(
    current_user,
    record
  )
end

def forbidden_response
  render json: {
    error: "Forbidden"
  }, status: :forbidden
end

end