module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |error|
      render json: { error: error.message }, status: :not_found
    end

    rescue_from ActiveRecord::RecordInvalid do |error|
      render json: { errors: error.record.errors.full_messages }, status: :unprocessable_entity
    end

    rescue_from ActionController::ParameterMissing do |error|
      render json: { error: error.message }, status: :bad_request
    end

    rescue_from Auth::LoginService::InvalidCredentialsError do
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end

    rescue_from Pundit::NotAuthorizedError do |error|
      render json: { error: "Forbidden" }, status: :forbidden
    end

  end
end