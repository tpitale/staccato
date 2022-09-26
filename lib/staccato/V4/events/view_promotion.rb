module Staccato::V4
  class ViewPromotion
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
