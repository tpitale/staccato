require 'ostruct'
require 'net/http'
require 'forwardable'
require 'securerandom'

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
  # @param hostname [String, Integer, nil] target website's hostname, needed
  #   when using the same GA tracker id for more than one website
  # @return [Staccato::Tracker] a new tracker is returned
  def self.tracker(id, client_id = nil, hostname = nil)
    if id.nil?
      Staccato::NoopTracker.new
    else
      Staccato::Tracker.new(id, client_id, hostname)
    end
  end

  # Build a new random `client_id`
  # 
  # @return [String] a random value suitable for use as a `client_id`
  def self.build_client_id
    SecureRandom.uuid
  end

  # The tracking endpoint we use to submit requests to GA
  def self.tracking_uri
    URI('http://www.google-analytics.com/collect')
  end
end

require 'staccato/option_set'
require 'staccato/hit'
require 'staccato/pageview'
require 'staccato/event'
require 'staccato/social'
require 'staccato/exception'
require 'staccato/timing'
require 'staccato/transaction'
require 'staccato/transaction_item'
require 'staccato/tracker'
