module Staccato
  # Pageview Hit type field definitions
  # @author Tony Pitale
  class Pageview
    # Pageview field definitions
    FIELDS = {
      hostname: 'dh',
      path: 'dp',
      title: 'dt'
    }

    include Hit

    # pageview hit type
    def type
      :pageview
    end
  end
end
