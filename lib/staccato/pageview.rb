module Staccato
  # Pageview Hit type field definitions
  # @author Tony Pitale
  class Pageview
    # Pageview field definitions
    FIELDS = {
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
