module Staccato
  class Exception
    FIELDS = {
      description: 'exd',
      fatal: 'exf'
    }

    include Hit

    def initialize(*)
      super
      options[:fatal] = 1 if options[:fatal]
    end

    def type
      :exception
    end
  end
end
