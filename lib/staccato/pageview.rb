module Staccato
  # Pageview Hit type field definitions
  # @author Tony Pitale
  class Pageview
    # Pageview field definitions
    FIELDS = {
      client_id: 'cid',
      hostname: 'dh', # moved to GLOBAL_OPTIONS
      page: 'dp', # moved to GLOBAL_OPTIONS
      title: 'dt' # moved to GLOBAL_OPTIONS
    }

    include Hit

    # pageview hit type
    def type
      :pageview
    end
  end
end
