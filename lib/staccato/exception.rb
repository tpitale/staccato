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

    # exception hit type
    def type
      :exception
    end

    # Boolean fields from Hit plus exception-specific field
    # @return [Array<Symbol>]
    def boolean_fields
      super + [:fatal]
    end
  end
end
