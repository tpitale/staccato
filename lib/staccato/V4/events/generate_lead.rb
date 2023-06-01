module Staccato::V4
  class GenerateLead
    FIELDS = [
      :currency,
      :value
    ]

    include Event
  end
end
