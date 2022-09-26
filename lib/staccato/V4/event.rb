module Staccato::V4
  module Event
    # this module is included into each model hit type
    #   to share the common behavior required to hit
    #   the Google Analytics /collect api endpoint
    def self.included(event)
      event.extend Forwardable

      event.class_eval do
        attr_accessor :tracker, :options

        def_delegators :@options, *event::FIELDS
      end
    end

    def initialize(tracker, options = {})
      self.tracker = tracker
      self.options = Staccato::OptionSet.new(options)
    end

    # return the fields for this hit type
    # @return [Array] the fields
    def fields
      self.class::FIELDS
    end

    def as_json
      {
        name: name,
        params: event_params
      }
    end

    private
    def event_params
      Hash[
        fields.map { |field,key|
          [key, options[field]] unless options[field].nil?
        }.compact
      ]
    end

    # include BooleanHelpers
    # adds convert_booleans()
  end
end

require_relative 'events/item'
require_relative 'events/add_payment_info'