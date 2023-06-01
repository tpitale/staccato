module Staccato::V4
  class SpendVirtualCurrency
    FIELDS = [
      :value,
      :virtual_currency_name,
      :item_name
    ]

    include Event
  end
end
