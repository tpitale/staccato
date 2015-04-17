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
      fields.each_with_object({}) { |(field,key), params|
        next if key.nil?
        key = (prefix+key.to_s)

        if options[field].is_a?(Array)
          options[field].each { |custom_data|
            custom_key = (key+custom_data[0].to_s)

            params[custom_key] = custom_data[1]
          }
        else
          params[key] = options[field] unless options[field].nil?
        end
      }
    end
  end
end
