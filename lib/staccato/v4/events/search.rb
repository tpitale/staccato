# frozen_string_literal: true

module Staccato::V4
  class Search
    FIELDS = [
      :search_term
    ]

    include Event
  end
end
