# frozen_string_literal: true

module Staccato::V4
  class ViewSearchResults
    FIELDS = [
      :search_term,
      :items
    ]

    include Event
  end
end
