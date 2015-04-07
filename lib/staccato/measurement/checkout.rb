module Staccato
  module Measurement
    # Measurement class for checkout action steps
    class Checkout
      # lookup key for use in Hit#add_measurement
      # @return [Symbol]
      def self.lookup_key
        :checkout
      end

      # Checkout measurement options fields
      FIELDS = {
        step: 'cos', # integer
        step_options: 'col' # text
      }.freeze

      include Measurable
    end
  end
end