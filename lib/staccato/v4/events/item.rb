module Staccato::V4
  Item = Struct.new(
    :item_id,
    :item_name,
    :affiliation,
    :coupon,
    :currency,
    :discount,
    :index,
    :item_brand,
    :item_category,
    :item_category2,
    :item_category3,
    :item_category4,
    :item_category5,
    :item_list_id,
    :item_list_name,
    :item_variant,
    :location_id,
    :price,
    :quantity
  )
  # may need to override as_json to get a map
end
