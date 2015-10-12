module Staccato
  # The `Hit` module enables a class to track the appropriate parameters
  #   to Google Analytics given a defined set of `FIELDS` in a map between
  #   the option name and its specified GA field name
  #
  # @author Tony Pitale
  module Hit
    # this module is included into each model hit type
    #   to share the common behavior required to hit
    #   the Google Analytics /collect api endpoint
    def self.included(model)
      model.extend Forwardable

      model.class_eval do
        attr_accessor :tracker, :options

        def_delegators :@options, *model::FIELDS.keys
      end
    end

    # Hit global options may be set on any hit type options
    GLOBAL_OPTIONS = {
      anonymize_ip: 'aip', # boolean
      queue_time: 'qt', # integer
      data_source: 'ds',
      cache_buster: 'z',
      user_id: 'uid', # a known user's id

      # Session, works with session control
      user_ip: 'uip',
      user_agent: 'ua',

      # Traffic Sources
      referrer: 'dr',
      campaign_name: 'cn',
      campaign_source: 'cs',
      campaign_medium: 'cm',
      campaign_keyword: 'ck',
      campaign_content: 'cc',
      campaign_id: 'ci',
      adwords_id: 'gclid',
      display_ads_id: 'dclid',

      # System Info
      screen_resolution: 'sr',
      viewport_size: 'vp',
      screen_colors: 'sd',
      user_language: 'ul',
      java_enabled: 'je', # boolean
      flash_version: 'fl',
      non_interactive: 'ni', # boolean
      document_location: 'dl',
      document_encoding: 'de', # duplicate of encoding
      document_hostname: 'dh', # duplicate of hostname
      document_path: 'dp', # duplicate of path
      document_title: 'dt', # duplicate of title
      screen_name: 'cd', # screen name is not related to custom dimensions
      link_id: 'linkid',

      # App Tracking
      application_name: 'an',
      application_id: 'aid',
      application_installer_id: 'aiid',
      application_version: 'av',

      # Content Experiments
      experiment_id: 'xid',
      experiment_variant: 'xvar',

      # Product
      product_action: 'pa',
      product_action_list: 'pal',

      # Promotion
      promotion_action: 'promoa',

      # Location
      geographical_id: 'geoid'
    }.freeze

    # Fields which should be converted to boolean for google
    BOOLEAN_FIELDS = [
      :non_interactive,
      :anonymize_ip,
      :java_enabled
    ].freeze

    # sets up a new hit
    # @param tracker [Staccato::Tracker] the tracker to collect to
    # @param options [Hash] options for the specific hit type
    def initialize(tracker, options = {})
      self.tracker = tracker
      self.options = OptionSet.new(convert_booleans(options))
    end

    # return the fields for this hit type
    # @return [Hash] the field definitions
    def fields
      self.class::FIELDS
    end

    # collects the parameters from options for this hit type
    def params
      {}.
      merge!(base_params).
      merge!(tracker_default_params).
      merge!(global_options_params).
      merge!(hit_params).
      merge!(custom_dimensions).
      merge!(custom_metrics).
      merge!(measurement_params).
      reject {|_,v| v.nil?}
    end

    # Set a custom dimension value at an index
    # @param index [Integer]
    # @param value
    def add_custom_dimension(index, value)
      self.custom_dimensions["cd#{index}"] = value
    end

    # Custom dimensions for this hit
    # @return [Hash]
    def custom_dimensions
      @custom_dimensions ||= {}
    end

    # Set a custom metric value at an index
    # @param index [Integer]
    # @param value
    def add_custom_metric(index, value)
      self.custom_metrics["cm#{index}"] = value
    end

    # Custom metrics for this hit
    # @return [Hash]
    def custom_metrics
      @custom_metrics ||= {}
    end

    # Add a measurement by its symbol name with options
    #
    # @param key [Symbol] any one of the measurable classes lookup key
    # @param options [Hash or Object] for the measurement
    def add_measurement(key, options = {})
      if options.is_a?(Hash)
        self.measurements << Measurement.lookup(key).new(options)
      else
        self.measurements << options
      end
    end

    # Measurements for this hit
    # @return [Array<Measurable>]
    def measurements
      @measurements ||= []
    end

    # Returns the value for session control
    #   based on options for session_start/_end
    # @return ['start', 'end']
    def session_control
      case
      when options[:session_start], options[:start_session]
        'start'
      when options[:session_end], options[:end_session], options[:stop_session]
        'end'
      end
    end

    # send the hit to the tracker
    def track!
      tracker.track(params)
    end

    private
    # @private
    def boolean_fields
      BOOLEAN_FIELDS
    end

    include BooleanHelpers

    # @private
    def base_params
      {
        'v' => 1, # protocol version
        'tid' => tracker.id, # tracking/web_property id
        'cid' => tracker.client_id, # unique client id
        'sc' => session_control,
        't' => type.to_s
      }
    end

    # @private
    def global_options_params
      Hash[
        options.map { |k,v|
          [GLOBAL_OPTIONS[k], v] if global_option?(k)
        }.compact
      ]
    end

    # @private
    def tracker_default_params
      Hash[
        tracker.hit_defaults.map { |k,v|
          [GLOBAL_OPTIONS[k], v] if global_option?(k)
        }.compact
      ]
    end

    # @private
    def global_option?(key)
      GLOBAL_OPTIONS.keys.include?(key)
    end

    # @private
    def hit_params
      Hash[
        fields.map { |field,key|
          [key, options[field]] unless options[field].nil?
        }.compact
      ]
    end

    # @private
    def measurement_params
      measurements.dup.map!(&:params).inject({}, &:merge!)
    end
  end
end
