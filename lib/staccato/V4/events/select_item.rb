module Staccato::V4
  class SelectItem
    FIELDS = [
      :item_list_id,
      :item_list_name,
      :items
    ]

    include Event
  end
end
