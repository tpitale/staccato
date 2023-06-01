module Staccato::V4
  class AddPaymentInfo
    FIELDS = [
      :currency,
      :value,
      :coupon,
      :payment_type,
      :items
    ]

    include Event
  end
end
