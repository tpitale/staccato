module Staccato
  class Event
    FIELDS = {
      category: 'ec',
      action: 'ea',
      label: 'el',
      value: 'ev'
    }

    include Hit

    def type
      :event
    end
  end
end
