# frozen_string_literal: true

module Staccato::V4
  class AddPaymentInfo
    FIELDS = %i[
      currency
      value
      coupon
      payment_type
      items
    ]

    include Event
  end
end
