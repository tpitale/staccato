module Staccato::V4
  class LevelUp
    FIELDS = [
      :level,
      :character
    ]

    include Event
  end
end
