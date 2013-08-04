module Staccato
  class Social
    FIELDS = {
      action: 'sa',
      network: 'sn',
      target: 'st'
    }

    include Hit

    def type
      :social
    end
  end
end
