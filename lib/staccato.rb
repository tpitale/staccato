require 'ostruct'
require 'net/http'
require 'forwardable'
require 'securerandom'

require "staccato/version"

module Staccato
  def self.tracker(id, client_id = nil)
    if id.nil?
      Staccato::NoopTracker.new
    else
      Staccato::Tracker.new(id, client_id)
    end
  end

  def self.build_client_id
    SecureRandom.uuid
  end

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
require 'staccato/tracker'
