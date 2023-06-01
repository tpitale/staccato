# frozen_string_literal: true

module Staccato::V4
  class PostScore
    FIELDS = [
      :score,
      :level,
      :character
    ]

    include Event
  end
end
