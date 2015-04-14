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
  # @return [Staccato::Tracker] a new tracker is returned
  def self.tracker(id, client_id = nil, hit_options = {})
    validate = hit_options.delete(:validate) { |_| false }
    if id.nil?
      Staccato::NoopTracker.new
    elsif validate == true
      Staccato::ValidationTracker.new(id, client_id,  hit_options)
    else
      Staccato::Tracker.new(id, client_id, hit_options)
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

  # The tracking endpoint for request validation
  def self.validation_uri
    URI('https://www.google-analytics.com/debug/collect')
  end
end

require 'staccato/boolean_helpers'
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
require 'staccato/measurement'
