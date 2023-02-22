require 'json'

module Staccato
  module V4
    # Build a new tracker instance
    #   If the first argument is explicitly `nil`, a `NoopTracker` is returned
    #   which responds to all the same `tracker` methods but does no tracking
    # 
    # @param measurement_id [String] the required id provided by google, i.e., `G-XXXXXXXX`
    # @param client_id [String, Integer, nil] a unique id to track the session of
    #   an individual user
    # @param options [Hash] options for use in all hits from this tracker
    # @yield [Staccato::Tracker] the new tracker
    # @return [Staccato::Tracker] a new tracker is returned
    def self.tracker(measurement_id, api_secret, client_id = nil, options = {})
      klass = measurement_id.nil? ? Staccato::V4::NoopTracker : Staccato::V4::Tracker

      klass.new(measurement_id, api_secret, client_id, options).tap do |tracker|
        yield tracker if block_given?
      end
    end

    # The tracking endpoint we use to submit requests to GA
    def self.ga_collection_uri
      URI('https://www.google-analytics.com/mp/collect')
    end

    # The tracking endpoint we use to submit requests to GA
    def self.validation_uri
      URI('https://www.google-analytics.com/debug/mp/collect')
    end

    # The default adapter to use for sending hits
    def self.default_adapter
      require 'staccato/adapter/net_http'
      Staccato::Adapter::Net::HTTP
    end

    # JSON encode in the case of GA measurement protocol V4
    def self.encode_body(client_id, events)
      JSON.generate({
        client_id: client_id,
        events: events
      })
    end
  end
end

require_relative 'option_set'
require_relative 'v4/event'

# define tracker last so any events have dynamically defined methods
require_relative 'v4/tracker'
