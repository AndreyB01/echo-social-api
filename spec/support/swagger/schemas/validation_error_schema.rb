# frozen_string_literal: true

ValidationErrorSchema = {
  type: :object,
  properties: {
    errors: {
      type: :array,
      items: {
        type: :string
      }
    }
  },
  required: ["errors"]
}.freeze
