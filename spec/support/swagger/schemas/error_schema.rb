# frozen_string_literal: true

ErrorSchema = {
  type: :object,
  properties: {
    error: {
      type: :string,
      example: "Invalid credentials"
    }
  },
  required: ["error"]
}.freeze
