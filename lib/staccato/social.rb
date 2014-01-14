module Staccato
  # Social Hit type field definitions
  # @author Tony Pitale
  class Social
    # Social field definitions
    FIELDS = {
      action: 'sa',
      network: 'sn',
      target: 'st'
    }

    include Hit

    # social hit type
    def type
      :social
    end
  end
end
