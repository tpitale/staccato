module Staccato::V4
  class EarnVirtualCurrency
    FIELDS = [
      :virtual_currency_name,
      :value
    ]

    include Event
  end
end
