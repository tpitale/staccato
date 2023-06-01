module Staccato::V4
  class Share
    FIELDS = [
      :method,
      :content_type,
      :item_id
    ]

    include Event
  end
end
