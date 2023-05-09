# frozen_string_literal: true

require_relative 'adapter_defaults'
require_relative 'event' # must load first, to dynamically define event methods

module Staccato::V4
  # The `Tracker` class has methods to create all `Hit` types
  #   using the measurement_id, api_secret, and client_id.
  #
  # @author Tony Pitale
  class Tracker
    extend Staccato::V4::AdapterDefaults

    attr_reader :measurement_id, :api_secret

    # sets up a new tracker
    # @param measurement_id [String] the identifier for a Data Stream
    #     provided by google, i.e., `G-XXXXXXXX`
    # @param api_secret [String] the required API Secret that is generated
    #     through the Google Analytics UI
    # @param client_id [String] uniquely identifies a user instance of a web
    #     client
    # @param user_id [String, nil] A unique identifier for a user
    # @param user_properties [Hash] custom user properties that describe
    #     segments of your user base, such as language preference or geographic
    #     location
    # @param non_personalized_ads [Boolean] Set to true to indicate these events
    #     should not be used for personalized ads
    # @param time [Time] The time to associate with the event.  This should
    #     only be set to record events that happened in the past.  This value
    #     can be overridden via user_property or event timestamps.
    # @param default_event_params [Hash] default event params used by all events
    #     sent from this tracker
    def initialize(measurement_id, api_secret, client_id,
                   user_id: nil, user_properties: nil,
                   non_personalized_ads: nil,
                   time: nil, timestamp_micros: nil,
                   default_event_params: {})
      raise ArgumentError, 'measurement_id is required' unless measurement_id
      raise ArgumentError, 'api_secret is required'     unless api_secret
      raise ArgumentError, 'client_id is required'      unless client_id
      if time && timestamp_micros
        raise ArgumentError, 'time and timestamp_micros are mutually exclusive'
      end

      @measurement_id       = measurement_id
      @api_secret           = api_secret
      @client_id            = client_id
      @user_id              = user_id
      @user_properties      = user_properties&.to_hash
      @default_event_params = default_event_params.to_hash
      @time                 = time&.to_time
      @timestamp_micros     = Integer(timestamp_micros) if timestamp_micros

      if @timestamp_micros then @time = Time.at(@timestamp_micros / 1_000_000)
      elsif @time then @timestamp_micros = Staccato::V4.timestamp_micros(@time)
      end

      @adapters = []
      @events   = []
    end

    def adapter=(adapter)
      @adapters = [adapter]
    end

    # Adds an adapter to the Tracker.  If no adapter was explicitly added, this
    # will be the only adapter for the tracker.
    #
    # To add an adapter in addition to the {.default_adapter}, add it directly
    # to the adapters array:
    #
    #    tracker.adapters << Staccato::Adapter::Logger.new
    #
    # @param adapter [Object] an adapter object, or use one of the following
    #     symbols to configure a default adapter: `:net_http`, `:validation`,
    #     `:logger`.
    # @param logger [Logger] used when `adapter` is `:logger`
    # @param formatter [Proc] used when `adapter` is `:logger`
    def add_adapter(adapter, logger = nil, formatter = nil)
      case adapter
      when :logger
        require 'staccato/adapter/logger'
        uri = self.class.collection_uri
        adapter = Staccato::Adapter::Logger.new(uri, logger, formatter)
      when :net_http
        adapter = self.class.default_adapter
      when :validation
        adapter = self.class.validation_adapter
      end
      @adapters << adapter
      adapter
    end

    # The identifier for a Data Stream provided by google, i.e., `G-XXXXXXXX`
    # @return [String]
    attr_reader :measurement_id

    # The required API Secret that is generated through the Google Analytics UI
    # @return [String]
    attr_reader :api_secret

    # uniquely identifies a user instance of a web client
    # @return [String]
    attr_reader :client_id

    # An optional unique identifier for a user.  Optional.
    # @return [String, nil]
    attr_reader :user_id

    # User properties describe segments of your user base, such as language
    # preference or geographic location.  Optional.
    # @return [Hash]
    attr_reader :user_properties

    # Indicates that these events should not be used for personalized ads
    # @return [Boolean]
    attr_reader :non_personalized_ads

    # The time to associate with events.  This should only be set to record
    # events that happened in the past.  This value can be overridden via
    # user_property or event timestamps.
    #
    # When set, this returns the Time associated with {#timestamp_micros}.
    #
    # See {Staccato::V4.timestamp_micros}.
    #
    # @return [Time, nil]
    attr_reader :time

    # The time to associate with the events, as a Unix timestamp in
    # microseconds.  It is recommended to use {#time} instead.
    # @return (see #time)
    attr_reader :timestamp_micros

    # The default event parameters used in all events sent from this tracker
    # @return [Hash]
    attr_reader :default_event_params

    # Use {#<<}, {#add}, {#clear}, or {#trim} to update the events.  The array
    # is a frozen duplicate, which cannot be updated directly.
    #
    # Note: Requests can have a maximum of 25 events each.  When more than 25
    # events are present, multiple HTTP requests will be sent.
    #
    # @return [Array[Staccato::V4::Event]] the unsent events
    def events; @events.dup.freeze end

    # Add an event to the events to be sent, and return self.
    #
    # @param time [Time] The time to associate with the event.  This should only
    #     be set to record events that happened in the past.  It will be
    #     translated into a timestamp_micros event parameter.
    # @param params [Time] event parameters to me used with the event
    # @return self
    def add(event, time: nil, **params)
      params[:timestamp_micros] = Staccato::V4.timestamp_micros(time) if time
      case event
      when Class
        unless event <= Staccato::V4::Event
          raise ArgumentError, 'expected subclass of Staccato::V4::Event'
        end
        @events << event.new(**default_event_params, **params)
      when Event
        @events << event.with_defaults!(default_event_params).update(params)
      when String, Symbol
        add({name: event.to_sym}, **params)
      when Hash
        if (event.keys - %i[name params]).any?
          raise ArgumentError, 'only valid event keys are :name and :params'
        end
        name   = event.fetch(:name).to_sym
        params = default_event_params.merge(event.fetch(:params, {}), params)
        @events << {name: name, params: params.empty? ? nil : params}.compact
      else
        raise ArgumentError, 'expected Event object or class, or event hash'
      end
      self
    end

    # Add an event to the events to be sent, and return self.
    #
    # Use {#add} to also set event parameters.
    #
    # @return self
    def << event
      add(event)
      self
    end

    # dynamically define methods for events
    Staccato::V4::Event.events.each do |event_name, event_klass|
      define_method event_name do |**params|
        add(event_klass, **params)
        self
      end

      define_method :"#{event_name}!" do |**params|
        add(event_klass, **params).then { track }
      end
    end

    # Post batches of the collected {#events} to the Google Analytics V4
    # Measurement Protocol endpoint.
    #
    # {#events} will be cleared as they are successfully posted.
    #
    # Note: Requests can have a maximum of 25 events each.  When {#events} is
    # larger than `batch_size`, the adapters receive multiple requests.
    #
    # The Google Analytics Measurement API always returns a 200 OK response.
    # With the default adapter, that is a Net::HTTPOK object.
    #
    # @return [Array<Net::HTTPOK, Array<Net::HTTPOK>] An array of results with
    #     one entry for each batch.  With multiple adapters, each result is
    #     an array with one entry per adapter.
    def post(batch_size: 25)
      batch_size = Integer(batch_size)
      results = []
      while @events.any?
        results << post_batch(batch_size: batch_size)
        trim(count: batch_size)
      end
      results
    end

    # (see #post)
    def track
      post
    end

    # Remove the first `count` events from the {#events} array.
    #
    # Related: {#clear}
    #
    # @return self
    def trim(count: 25)
      @events.slice!(0, count)
      self
    end

    # Remove the first `count` events from the {#events} array.
    #
    # Related: {#trim}
    #
    # @return self
    def clear
      @events.clear
      self
    end

    # Post the first batch_size {#events} to the Measurement Protocol API
    # Validation Server endpoint.
    #
    # Note that, unlike {#track}, the {#events} array will not be automatically
    # cleared.
    def validate!
      self.class.validation_adapter.post_with_body(query_params, body)
    end

    def query_params
      { measurement_id: measurement_id, api_secret: api_secret }
    end

    # n.b. only the first batch_size events are included
    def as_json(batch_size: 25)
      {
        client_id: client_id,
        user_id: user_id,
        user_properties: user_properties,
        non_personalized_ads: non_personalized_ads,
        timestamp_micros: timestamp_micros,
        events: Staccato::V4.encode_params_json(@events[0, batch_size])
      }.compact.reject {|k, v| v.nil? || v.respond_to?(:empty?) && v.empty? }
    end

    def adapters
      @adapters << self.class.default_adapter if @adapters.empty?
      @adapters
    end

    private

    def body(batch_size:)
      JSON.generate(as_json(batch_size: batch_size))
    end

    def post_batch(batch_size:, adapters: self.adapters)
      if adapters.length == 1
        adapters.first.post_with_body(
          query_params,
          body(batch_size: batch_size)
        )
      else
        query_params = self.query_params
        body         = body(batch_size: batch_size)
        adapters.map {|adapter| adapter.post_with_body(query_params, body)}
      end
    end
  end

  # A tracker which does no tracking
  #   Useful in testing
  class NoopTracker < Tracker
    attr_accessor :hit_defaults

    def initialize(measurement_id = nil,
                   api_secret = nil,
                   client_id = nil,
                   **kwargs)
      super
    end

    def adapters; [] end

    def adapter=(*) [] end

    def add_adapter(*) [] end

    # (see Tracker#add)
    def add(event_klass, params) end

    # (see Tracker#<<)
    def <<(event) end

    # (see Tracker#post)
    def post; end

    # (see Tracker#track)
    def track; end

    # (see Tracker#validate!)
    def validate!; end

  end
end
