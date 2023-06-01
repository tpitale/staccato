module Staccato::V4
  class SelectContent
    FIELDS = [
      :content_type,
      :item_id
    ]

    include Event
  end
end
