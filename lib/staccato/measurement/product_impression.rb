module Staccato
  module Measurement
    # Measurement class for product impressions in a list
    class ProductImpression
      # lookup key for use in Hit#add_measurement
      # @return [Symbol]
      def self.lookup_key
        :product_impression
      end

      # product impress prefix
      # @return [String]
      def prefix
        'il' + list_index.to_s + 'pi' + index.to_s
      end

      # product impression allow custom dimensions and metrics
      def custom_fields_allowed?
        true
      end

      # Product impression measurement options fields
      FIELDS = {
        index: nil,
        list_index: nil,
        id: 'id', # text
        name: 'nm', # text
        brand: 'br', # text
        category: 'ca', # text
        variant: 'va', # text
        price: 'pr', # currency (looks like a double?)
        position: 'ps' # integer
      }.freeze

      include Measurable
    end
  end
end
