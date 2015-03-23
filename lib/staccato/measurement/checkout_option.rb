module Staccato
  module Measurement
    # Measurement class for checkout options
    class CheckoutOption
      # lookup key for use in Hit#add_measurement
      # @return [Symbol]
      def self.lookup_key
        :checkout_option
      end

      # Checkout option measurement options fields
      FIELDS = {
        step: 'cos', # integer
        step_options: 'col' # text
      }.freeze

      include Measurable
    end
  end
end
