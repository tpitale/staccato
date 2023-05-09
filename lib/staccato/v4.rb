# frozen_string_literal: true

require 'json'
require_relative 'v4/adapter_defaults'
require_relative 'v4/event'
require_relative 'v4/tracker'

module Staccato

  # The namespace for Google Analytics V4 classes and modules.
  #
  # V4 utility methods are also defined here.
  module V4
    extend AdapterDefaults

    # Build a new tracker instance
    #   If measurement_id, api_secret, or client_id are explicitly `nil`, a
    #   `NoopTracker` is returned which responds to all the same `tracker`
    #   methods but does no tracking
    #
    # (see Tracker#initialize)
    #
    # @yield [Staccato::Tracker] the new tracker
    # @return [Staccato::Tracker] a new tracker is returned
    def self.tracker(measurement_id, api_secret, client_id, **options)
      klass = Staccato::V4::Tracker if measurement_id && api_secret && client_id
      klass ||= Staccato::V4::NoopTracker

      klass.new(measurement_id, api_secret, client_id, **options).tap do |tracker|
        yield tracker if block_given?
      end
    end

    # @return [Integer] the number of microseconds since the UNIX epoch
    def self.timestamp_micros(time = Time.now)
      time = Time.now if time == true || time.nil?
      Integer(Float(time) * 1_000_000)
    end

    def self.encode_params_json(params)
      case params
      when Hash, Struct
        params
          .to_h {|k, v| [k.to_sym, encode_params_json(v)] }
          .compact.reject {|k, v| v.respond_to?(:empty?) && v.empty? }
      when Integer, Float, String, Symbol
        params
      when Array
        params.map {|param| encode_params_json(param) }
      else
        params.respond_to?(:as_json) ? params.as_json : params
      end
    end

  end
end
