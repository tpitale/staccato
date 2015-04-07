require 'staccato/measurable'
require 'staccato/null_measurement'

require 'staccato/measurement/checkout'
require 'staccato/measurement/checkout_option'
require 'staccato/measurement/impression_list'
require 'staccato/measurement/product'
require 'staccato/measurement/product_impression'
require 'staccato/measurement/promotion'
require 'staccato/measurement/transaction'

module Staccato
  # Classes for measurements to be add to Hits
  module Measurement
    # List of measurement classes by lookup key
    TYPES = Hash[
      [
        Checkout,
        CheckoutOption,
        ImpressionList,
        Product,
        ProductImpression,
        Promotion,
        Transaction
      ].map { |k| [k.lookup_key, k] }
    ].freeze

    # Lookup a measurement class by its key
    # @param key [Symbol]
    # @return [Class] measurement class or NullMeasurement
    def lookup(key)
      measurement_types[key] || NullMeasurement
    end
    module_function :lookup

    # List of measurement classes by lookup key
    # @return [Hash]
    def measurement_types
      TYPES
    end
    module_function :measurement_types
  end
end
