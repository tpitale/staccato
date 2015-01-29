module Staccato
  # Exception Hit type field definitions
  # @author Tony Pitale
  class Exception
    # Exception field definitions
    FIELDS = {
      client_id: 'cid',
      description: 'exd',
      fatal: 'exf'
    }

    include Hit

    # exception hit type
    def type
      :exception
    end

    def boolean_fields
      super << :fatal
    end
  end
end
