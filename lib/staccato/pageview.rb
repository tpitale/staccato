module Staccato
  # Pageview Hit type field definitions
  # @author Tony Pitale
  class Pageview
    # Pageview field definitions
    FIELDS = {
      hostname: 'dh', # moved to GLOBAL_OPTIONS
      path: 'dp', # moved to GLOBAL_OPTIONS
      title: 'dt' # moved to GLOBAL_OPTIONS
    }

    include Hit

    # pageview hit type
    def type
      :pageview
    end
  end
end
