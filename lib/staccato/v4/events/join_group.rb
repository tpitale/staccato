# frozen_string_literal: true

module Staccato::V4
  class JoinGroup
    FIELDS = [
      :group_id
    ]

    include Event
  end
end
