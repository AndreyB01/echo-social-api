# frozen_string_literal: true

UnauthorizedErrorSchema = {
  type: :object,
  properties: {
    error: {
      type: :string,
      example: "Invalid credentials"
    }
  },
  required: ["error"]
}.freeze
