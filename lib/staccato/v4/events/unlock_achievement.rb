# frozen_string_literal: true

module Staccato::V4
  class UnlockAchievement
    FIELDS = [
      :achievement_id
    ]

    include Event
  end
end
