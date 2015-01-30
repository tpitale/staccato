module Staccato
  # Social Hit type field definitions
  # @author Tony Pitale
  class Social
    # Social field definitions
    FIELDS = {
      client_id: 'cid',
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
