module Staccato::V4
  class Purchase
    FIELDS = %i[
      currency
      transaction_id
      value
      affiliation
      coupon
      shipping
      tax
      items
    ]

    include Event
  end
end