# frozen_string_literal: true

PaginationMetaSchema = {
  type: :object,
  properties: {
    next_cursor: {
      type: :string,
      nullable: true,
      example: nil
    },
    limit: {
      type: :integer,
      example: 20
    },
    has_next: {
      type: :boolean,
      example: false
    }
  },
  required: %w[
    limit
    has_next
  ]
}.freeze