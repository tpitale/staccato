module Staccato::V4
  class BeginCheckout
    FIELDS = [
      :currency,
      :value,
      :coupon,
      :items
    ]

    include Event
  end
end
