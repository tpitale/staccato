module Staccato
  module Measurement
    # Measurement class for impressions in a list for products
    class ImpressionList
      # lookup key for use in Hit#add_measurement
      # @return [Symbol]
      def self.lookup_key
        :impression_list
      end

      # impression list prefix
      # @return [String]
      def prefix
        'il'+index.to_s
      end

      # Impression list measurement options fields
      FIELDS = {
        index: nil,
        name: 'nm'
      }.freeze

      include Measurable
    end
  end
end
