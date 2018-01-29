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

require 'staccato/boolean_helpers'
require 'staccato/option_set'
require 'staccato/hit'
require 'staccato/pageview'
require 'staccato/screenview'
require 'staccato/event'
require 'staccato/social'
require 'staccato/exception'
require 'staccato/timing'
require 'staccato/transaction'
require 'staccato/transaction_item'
require 'staccato/tracker'
require 'staccato/measurement'
