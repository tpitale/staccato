# frozen_string_literal: true

module Staccato::V4
  class AddToCart
    FIELDS = [
      :currency,
      :value,
      :items
    ]

    include Event
  end
end
