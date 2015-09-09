module Staccato
  # Screenview Hit type field definitions
  # @author Tony Pitale
  class Screenview
    # Screenview field definitions
    FIELDS = {}

    include Hit

    # pageview hit type
    def type
      :screenview
    end
  end
end
