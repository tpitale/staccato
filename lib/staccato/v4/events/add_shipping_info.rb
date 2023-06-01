module Staccato::V4
  class AddShippingInfo
    FIELDS = [
      :currency,
      :value,
      :coupon,
      :shipping_tier,
      :items
    ]

    include Event
  end
end
