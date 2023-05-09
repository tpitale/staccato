# frozen_string_literal: true

require_relative '../option_set'

module Staccato::V4
  module Event
    @events = {}

    class << self
      attr_reader :events

      # this module is included into each model hit type
      #   to share the common behavior required to hit
      #   the Google Analytics /mp/collect api endpoint
      def included(klass)
        klass.class_eval do
          extend ClassMethods
          extend Forwardable

          def_delegators :@options, :[], :[]=

          @recommended_params = []
          fields = defined?(klass::FIELDS) ? klass::FIELDS : []
          fields.each do |name|
            param name
          end

          # In order for user activity to display in standard reports like
          # Realtime, engagement_time_msec and session_id must be supplied as
          # part of the params for an event.
          param :engagement_time_msec
          param :session_id

          # The time to associate with the event, as a Unix timestamp in
          # microseconds.  This should only be set to record events that
          # happened in the past.
          #
          # Overrides the tracker timestamp_micros.
          param :timestamp_micros
        end

        events[klass.event_name] = klass
      end

    end

    module ClassMethods

      attr_reader :recommended_params

      def event_name
        @event_name ||= name
          .dup
          .split('::')
          .last
          .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
          .gsub(/([a-z\d])([A-Z])/, '\1_\2')
          .tr('-', '_')
          .downcase
          .to_sym
      end

      def param(name)
        # TODO: prevent assignment of restricted params
        name = name.to_sym
        recommended_params << name
        def_delegator :@options, name
      end

    end

    def initialize(**options)
      @options = Staccato::OptionSet.new(options)
    end

    def name
      self.class.event_name
    end

    def as_json
      Staccato::V4.encode_params_json({name: name, params: params})
    end

    def ==(other) other.class == self.class && other.as_json == as_json end
    alias_method :eql?, :==

    def hash; [self.class, as_json].hash end

    # The event parameters to be sent, including custom parameters
    # @return [Hash{Symbol=>Numeric,String,Array[Hash{Symbol=>Numeric,String}]}]
    def params
      Staccato::V4.encode_params_json options.to_h.compact
    end

    # The recommended parameter values for this event
    # @return (see params)
    def recommended_params
      self.class.recommended_params.map {|field|
        [field, options[field]] unless options[field].nil?
      }.compact.to_h
    end

    # The custom event parameters to be sent for this event
    # @return (see params)
    def custom_params
      official = self.class.recommended_params
      params.delete_if {|k, v| official.include? k }
    end

    # Adds and updates event parameters with the values in the params argument.
    # @return self
    def update(params)
      params.to_hash.each_pair do |key, value|
        options[key.to_sym] = value
      end
      self
    end
    alias_method :merge!, :update

    # Adds parameters to the event, where the event parameter wasn't already set.
    #
    # Note: This behaves like `Hash#with_defaults!` from `ActiveSupport`.
    #
    # @return self
    def with_defaults!(defaults)
      defaults.to_hash.each_pair do |key, value|
        key = key.to_sym
        options[key] = value unless options.to_h.key?(key)
      end
      self
    end
    alias_method :reverse_merge!, :update

    protected

    attr_reader :options

  end
end

require_relative 'events/item'

require_relative 'events/add_payment_info'
require_relative 'events/add_shipping_info'
require_relative 'events/add_to_cart'
require_relative 'events/add_to_wishlist'
require_relative 'events/begin_checkout'
require_relative 'events/earn_virtual_currency'
require_relative 'events/generate_lead'
require_relative 'events/join_group'
require_relative 'events/level_up'
require_relative 'events/login'
require_relative 'events/post_score'
require_relative 'events/purchase'
require_relative 'events/refund'
require_relative 'events/remove_from_cart'
require_relative 'events/search'
require_relative 'events/select_content'
require_relative 'events/select_item'
require_relative 'events/select_promotion'
require_relative 'events/share'
require_relative 'events/sign_up'
require_relative 'events/spend_virtual_currency'
require_relative 'events/tutorial_begin'
require_relative 'events/tutorial_complete'
require_relative 'events/unlock_achievement'
require_relative 'events/view_cart'
require_relative 'events/view_item'
require_relative 'events/view_item_list'
require_relative 'events/view_promotion'
require_relative 'events/view_search_results'
