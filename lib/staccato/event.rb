module Staccato
  # Event Hit type field definitions
  # @author Tony Pitale
  class Event
    # Event field definitions
    FIELDS = {
      client_id: 'cid',
      category: 'ec',
      action: 'ea',
      label: 'el',
      value: 'ev'
    }

    include Hit

    # event hit type
    def type
      :event
    end
  end
end
