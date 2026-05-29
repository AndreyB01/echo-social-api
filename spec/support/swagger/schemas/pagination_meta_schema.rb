# frozen_string_literal: true

PaginationMetaSchema = {
  type: :object,
  properties: {
    current_page: {
      type: :integer,
      example: 1
    },
    next_page: {
      type: :integer,
      nullable: true,
      example: nil
    },
    prev_page: {
      type: :integer,
      nullable: true,
      example: nil
    },
    total_pages: {
      type: :integer,
      example: 1
    },
    total_count: {
      type: :integer,
      example: 10
    }
  },
  required: %w[
    current_page
    total_pages
    total_count
  ]
}.freeze
