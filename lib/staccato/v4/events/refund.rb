# frozen_string_literal: true

module Staccato::V4
  class Refund
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
