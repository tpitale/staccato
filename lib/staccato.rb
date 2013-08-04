require 'ostruct'
require 'net/http'
require 'forwardable'
require 'securerandom'

require "staccato/version"

module Staccato
  def self.tracker(id, client_id = nil)
    Staccato::Tracker.new(id, client_id)
  end

  def self.tracking_uri
    URI('http://www.')
  end
end

require 'staccato/hit'
require 'staccato/pageview'
require 'staccato/event'
require 'staccato/social'
require 'staccato/exception'
require 'staccato/tracker'
