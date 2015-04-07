module Staccato
  # Measurable adds field mapping and param collection
  #   for Measurement classes to be add to Hit
  module Measurable
    def self.included(model)
      model.extend Forwardable

      model.class_eval do
        attr_accessor :options

        def_delegators :@options, *model::FIELDS.keys
      end
    end

    # @param options [Hash] options for the measurement fields
    def initialize(options = {})
      self.options = OptionSet.new(options)
    end

    # fields from options for this measurement
    def fields
      self.class::FIELDS
    end

    # measurement option prefix
    # @return [String]
    def prefix
      ''
    end

    # collects the parameters from options for this measurement
    # @return [Hash]
    def params
      Hash[
        fields.map { |field,key|
          next if key.nil?
          key = (prefix+key.to_s)

          [key, options[field]] unless options[field].nil?
        }.compact
      ]
    end
  end
end
