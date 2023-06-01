module Staccato::V4
  class Refund
    FIELDS = [
      :currency,
      :transaction_id,
      :value,
      :affiliation,
      :coupon,
      :shipping,
      :tax,
      :items
    ]

    include Event
  end
end
