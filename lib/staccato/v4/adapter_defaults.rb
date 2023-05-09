# frozen_string_literal: true

require 'uri'
module Staccato
  module V4

    # Provides the {#default_adapter} and {#validation_adapter} methods and
    # other related methods for Staccato::V4 and Staccato::V4::Tracker.  These
    # {#default_adapter} and {#validation_adapter} methods are memoized, but the
    # memoized values are not shared between any modules, classes, or subclasses
    # that extend this module.
    #
    # This allows subclass customization by overriding the appropriate uri or
    # class methods.
    module AdapterDefaults
      ENDPOINTS_ORIGIN = URI('https://www.google-analytics.com').freeze
      COLLECTION_URI = (ENDPOINTS_ORIGIN + '/mp/collect').freeze
      VALIDATION_URI = (ENDPOINTS_ORIGIN + '/debug/mp/collect').freeze

      # URI for the Google Analytics v4 Measurement Protocol
      #
      # See https://developers.google.com/analytics/devguides/collection/protocol/ga4/sending-events
      def collection_uri; COLLECTION_URI end

      # URI for the Google Analytics v4 Measurement Protocol Validation Server
      #
      # See https://developers.google.com/analytics/devguides/collection/protocol/ga4/validating-events
      def validation_uri; VALIDATION_URI end

      # The default adapter class to use for sending events
      # @return [Class]
      def default_adapter_class
        require 'staccato/adapter/net_http'
        Staccato::Adapter::Net::HTTP
      end

      # The default adapter class to use for validating events
      # @return [Class]
      def validation_adapter_class
        require 'staccato/adapter/validate'
        Staccato::Adapter::Validate
      end

      # Returns the default adapter, configured to use the default Google
      # Analytics v4 Management Protocol endpoint.
      #
      def default_adapter
        @default_adapter ||= default_adapter_class.new(collection_uri)
      end

      # Returns the validation adapter, configured to use the default Google
      # Analytics v4 Management Protocol Validation Server endpoint.
      #
      # The validation adapter instance is a singleton.
      def validation_adapter
        @validation_adapter ||= validation_adapter_class.new(
          default_adapter_class, validation_uri
        )
      end
    end

  end
end
