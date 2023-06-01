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
