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

    # not all measurements allow custom dimensions or metrics
    def custom_fields_allowed?
      false
    end

    # collects the parameters from options for this measurement
    # @return [Hash]
    def params
      {}.
      merge!(measurable_params).
      merge!(custom_dimensions).
      merge!(custom_metrics).
      reject {|_,v| v.nil?}
    end

    # Set a custom dimension value at an index
    # @param dimension_index [Integer]
    # @param value
    def add_custom_dimension(dimension_index, value)
      return unless custom_fields_allowed?
      self.custom_dimensions["#{prefix}cd#{dimension_index}"] = value
    end

    # Custom dimensions for this measurable
    # @return [Hash]
    def custom_dimensions
      @custom_dimensions ||= {}
    end

    # Set a custom metric value at an index
    # @param metric_index [Integer]
    # @param value
    def add_custom_metric(metric_index, value)
      return unless custom_fields_allowed?
      self.custom_metrics["#{prefix}cm#{metric_index}"] = value
    end

    # Custom metrics for this measurable
    # @return [Hash]
    def custom_metrics
      @custom_metrics ||= {}
    end

    private

    # @private
    def measurable_params
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
