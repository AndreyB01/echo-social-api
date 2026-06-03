class ApplicationController < ActionController::API
  include ApiResponse
  include ErrorHandler
  
  attr_reader :current_user

  private

  def authenticate_user!
      header = request.headers["Authorization"]
      return render_unauthorized unless header

      token = header.split(" ").last

      decoded_token =
        Jwt::AccessTokenDecoder.call(token)

      return render_unauthorized unless decoded_token

      @current_user =
        User.find(decoded_token["sub"])

    rescue ActiveRecord::RecordNotFound
      render_unauthorized
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