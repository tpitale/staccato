module Staccato
  # Exception Hit type field definitions
  # @author Tony Pitale
  class Exception
    # Exception field definitions
    FIELDS = {
      description: 'exd',
      fatal: 'exf'
    }

    include Hit

    def initialize(*)
      super
      options[:fatal] = 1 if options[:fatal]
    end

    # exception hit type
    def type
      :exception
    end
  end
end
