require 'staccato/adapter/validate'

module Staccato::V4
  # The `Tracker` class has methods to create all `Hit` types
  #   using the tracker and client id
  # 
  # @author Tony Pitale
  class Tracker
    attr_accessor :events

    # sets up a new tracker
    # @param measurement_id [String] the measurement id from GA
    # @param api_secret [String] the required api secret key
    # @param client_id [String, nil] unique value to track user sessions
    # @param options [Hash]
    def initialize(measurement_id, api_secret, client_id = nil, options = {})
      @measurement_id = measurement_id
      @api_secret = api_secret
      @client_id = client_id
      @adapters = []

      self.events = []
    end

    def adapter=(adapter)
      @adapters = [adapter]
    end

    def add_adapter(adapter)
      @adapters << adapter
    end

    # The measurement id for GA
    # @return [String]
    def measurement_id
      @measurement_id
    end

    # The required api secret for GA
    # @return [String]
    def api_secret
      @api_secret
    end

    # The unique client id
    # @return [String]
    def client_id
      @client_id ||= Staccato.build_client_id
    end

    # Add an Event instance to the events to be sent
    def add(event_name, options)
      event_object = {
        name: event_name,
        params: options
      }

      self.events << event_object
    end

    # dynamically define methods for events
    Staccato::V4::Event.events.each do |event_name, event_klass|
      define_method event_name do |options|
        add(event_name, options)
      end
    end

    # post the hit to GA collection endpoint
    # @return [Net::HTTPOK] the GA api always returns 200 OK
    def track
      post
    end

    def validate!
      Staccato::Adapter::Validate.new().post_with_body(params, body)
    end

    def default_uri
      Staccato::V4.ga_collection_uri
    end

    def validation_uri
      Staccato::V4.validation_uri
    end

    private

    # @private
    def params
      {
        measurement_id: @measurement_id,
        api_secret: @api_secret
      }
    end

    # @private
    def body
      Staccato::V4.encode_body(client_id, events)
    end

    # @private
    def single_adapter?
      adapters.length == 1
    end

    # @private
    def post
      single_adapter? ? post_first : post_all
    end

    # @private
    def post_first
      adapters.first.post_with_body(params, body)
    end

    # @private
    def post_all
      adapters.map {|adapter| adapter.post_with_body(params, body)}
    end

    # @private
    def adapters
      @adapters.empty? ? [default_adapter] : @adapters
    end

    # @private
    def default_adapter
      @default_adapter ||= Staccato.default_adapter.new(default_uri)
    end
  end

  # A tracker which does no tracking
  #   Useful in testing
  class NoopTracker
    attr_accessor :hit_defaults

    # (see Tracker#initialize)
    def initialize(measurement_id = nil, client_id = nil, options = {})
      self.events = []
    end

    def adapter=(*)
      []
    end

    def add_adapter(*)
      []
    end

    # (see Tracker#id)
    def measurement_id
      nil
    end

    # (see Tracker#client_id)
    def client_id
      nil
    end

    # (see Tracker#track)
    def track(events)
    end

    def default_uri
      Staccato::V4.ga_collection_uri
    end
  end
end
