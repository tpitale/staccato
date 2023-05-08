# frozen_string_literal: true

module Staccato::V4
  class AddShippingInfo
    FIELDS = %i[
      currency
      value
      coupon
      shipping_tier
      items
    ]

    include Event
  end
end
