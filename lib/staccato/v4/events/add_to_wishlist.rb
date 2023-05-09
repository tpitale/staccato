# frozen_string_literal: true

module Staccato::V4
  class AddToWishlist
    FIELDS = [
      :currency,
      :value,
      :items
    ]

    include Event
  end
end
