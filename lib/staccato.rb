require 'ostruct'
require 'forwardable'
require 'securerandom'
require 'uri'

require "staccato/version"

# The `Staccato` module namespace
# 
# @author Tony Pitale
module Staccato
  # Build a new tracker instance
  #   If the first argument is explicitly `nil`, a `NoopTracker` is returned
  #   which responds to all the same `tracker` methods but does no tracking
  # 
  # @param id [String, nil] the id provided by google, i.e., `UA-XXXXXX-Y`
  # @param client_id [String, Integer, nil] a unique id to track the session of
  #   an individual user
  # @param hit_options [Hash] options for use in all hits from this tracker
  # @yield [Staccato::Tracker] the new tracker
  # @return [Staccato::Tracker] a new tracker is returned
  def self.tracker(id, client_id = nil, options = {})
    klass = id.nil? ? Staccato::NoopTracker : Staccato::Tracker

    klass.new(id, client_id, options).tap do |tracker|
      yield tracker if block_given?
    end
  end

  # Build a new random `client_id`
  # 
  # @return [String] a random value suitable for use as a `client_id`
  def self.build_client_id
    SecureRandom.uuid
  end

  # The tracking endpoint we use to submit requests to GA
  def self.ga_collection_uri(ssl = false)
    url = (ssl ? 'https://' : 'http://') + 'www.google-analytics.com/collect'
    URI(url)
  end

  # The default adapter to use for sending hits
  def self.default_adapter
    require 'staccato/adapter/net_http'
    Staccato::Adapter::Net::HTTP
  end

  # Build a url string from any hit type
  # 
  # @param hit [Hit] anything that returns a hash for #params
  # @param uri [URI]
  # @return String
  def self.as_url(hit, uri = nil)
    uri ||= hit.tracker.default_uri

    uri.query = URI.encode_www_form(hit.params)
    uri.to_s
  end
end

require_relative 'staccato/boolean_helpers'
require_relative 'staccato/option_set'
require_relative 'staccato/hit'
require_relative 'staccato/pageview'
require_relative 'staccato/screenview'
require_relative 'staccato/event'
require_relative 'staccato/social'
require_relative 'staccato/exception'
require_relative 'staccato/timing'
require_relative 'staccato/transaction'
require_relative 'staccato/transaction_item'
require_relative 'staccato/tracker'
require_relative 'staccato/measurement'

require_relative 'staccato/v4'