module Staccato::V4
  module Event
    def self.events
      @events ||= {}
    end

    # this module is included into each model hit type
    #   to share the common behavior required to hit
    #   the Google Analytics /mp/collect api endpoint
    def self.included(event)
      event.extend Forwardable

      event.class_eval do
        attr_accessor :tracker, :options

        def_delegators :@options, *event::FIELDS

        # class name, underscored, symbolized
        def self.event_name
          @event_name || begin
            # gsub!(/::/, '/').
            self.
              to_s.
              dup.
              split("::").
              last.
              gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
              gsub(/([a-z\d])([A-Z])/,'\1_\2').
              tr("-", "_").
              downcase.
              to_sym
          end
        end
      end

      def name
        self.class.event_name
      end

      self.events[event.event_name] = event
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
        fields.map { |field|
          [field, options[field]] unless options[field].nil?
        }.compact
      ]
    end

    # include BooleanHelpers
    # adds convert_booleans()
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
require_relative 'events/item'
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
