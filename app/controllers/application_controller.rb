class ApplicationController < ActionController::API
  include ApiResponse
  include ErrorHandler
  
  attr_reader :current_user

  private

  def authenticate_user!
    header = request.headers["Authorization"]
    return render_unauthorized unless header

    token = header.split(" ").last

    begin
      decoded_token = Jwt::Decoder.call(token)
      @current_user = User.find(decoded_token["user_id"])
    rescue JWT::DecodeError,
           ActiveRecord::RecordNotFound
      return render_unauthorized
    end
  end

  def authorize(record, query)
    policy = policy_for(record)

    return if policy.public_send(query)

    render_forbidden
  end

  def policy_for(record)
    "#{record.class}Policy".constantize.new(
      current_user,
      record
    )
  end
end