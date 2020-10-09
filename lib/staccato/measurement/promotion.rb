module Staccato
  module Measurement
    # Measurement class for promotion impressions/clicks
    class Promotion
      # lookup key for use in Hit#add_measurement
      # @return [Symbol]
      def self.lookup_key
        :promotion
      end

      # promotion prefix
      # @return [String]
      def prefix
        'promo'+index.to_s
      end

      # Promotion measurement options fields
      FIELDS = {
        index: nil,
        id: 'id', # text
        name: 'nm', # text
        creative: 'cr', # text
        position: 'ps' # text
      }.freeze

      include Measurable

      def validate_options
        if @options[:index].nil?
          raise 'Index is required on Promotion measurements.'
        end
        true
      end
    end
  end
end
