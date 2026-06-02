module ApiResponse
  extend ActiveSupport::Concern

  private

  def render_success(data: nil, meta: nil, status: :ok)
    response = {
      success: true
    }

    response[:data] = data unless data.nil?
    response[:meta] = meta unless meta.nil?

    render json: response, status: status
  end

  def render_error(code:, message:, details: nil, status:)
    error = {
      code: code,
      message: message
    }

    error[:details] = details if details.present?

    render json: {
      success: false,
      error: error
    }, status: status
  end

  def render_validation_error(record)
    render_error(
      code: "validation_failed",
      message: "Validation failed",
      details: record.errors.to_hash,
      status: :unprocessable_entity
    )
  end

  def render_unauthorized
    render_error(
      code: "unauthorized",
      message: "Authentication required",
      status: :unauthorized
    )
  end

  def render_forbidden
    render_error(
      code: "forbidden",
      message: "Access denied",
      status: :forbidden
    )
  end

  def render_not_found(resource = "Resource")
    render_error(
      code: "not_found",
      message: "#{resource} not found",
      status: :not_found
    )
  end
end