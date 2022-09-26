module Staccato::V4
  class SelectPromotion
    FIELDS = [
      :creative_name,
      :creative_slot,
      :location_id,
      :promotion_id,
      :promotion_name,
      :items
    ]

    include Event
  end
end
