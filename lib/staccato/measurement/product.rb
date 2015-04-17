module Staccato
  module Measurement
    # Measurement class for products in a transaction or other action
    class Product
      # lookup key for use in Hit#add_measurement
      # @return [Symbol]
      def self.lookup_key
        :product
      end

      # product prefix
      # @return [String]
      def prefix
        'pr'+index.to_s
      end

      # Product measurement options fields
      FIELDS = {
        index: nil,
        id: 'id', # text
        name: 'nm', # text
        brand: 'br', # text
        category: 'ca', # text
        variant: 'va', # text
        price: 'pr', # currency (looks like a double?)
        quantity: 'qt', # integer
        coupon_code: 'cc', # text
        position: 'ps', # integer
        custom_dimensions: 'cd', # array[ array[ index, text ] ]
        custom_metrics: 'cm' # array[ array[ index, integer/currency] ]
      }.freeze

      include Measurable
    end
  end
end
