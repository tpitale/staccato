module Staccato::V4
  class AddPaymentInfo
    FIELDS = [
      :currency,
      :value,
      :coupon,
      :payment_type,
      :items
    ]

    def name
      :add_payment_info
    end

    include Event
  end
end
