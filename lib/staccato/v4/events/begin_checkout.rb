# frozen_string_literal: true

module Staccato::V4
  class BeginCheckout
    FIELDS = %i[
      currency
      value
      coupon
      items
    ]

    include Event
  end
end
