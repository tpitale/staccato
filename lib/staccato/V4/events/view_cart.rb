module Staccato::V4
  class ViewCart
    FIELDS = [
      :currency,
      :value,
      :items
    ]

    include Event
  end
end
