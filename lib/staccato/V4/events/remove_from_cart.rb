module Staccato::V4
  class RemoveFromCart
    FIELDS = [
      :currency,
      :value,
      :items
    ]

    include Event
  end
end
