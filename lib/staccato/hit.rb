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

    GLOBAL_OPTIONS = {
      anonymize_ip: 'aip', # boolean
      queue_time: 'qt', # integer
      cache_buster: 'z',
      referrer: 'dr',
      campaign_name: 'cn',
      campaign_source: 'cs',
      campaign_medium: 'cm',
      campaign_keyword: 'ck',
      campaign_content: 'cc',
      campaign_id: 'ci',
      adwords_id: 'gclid',
      display_ads_id: 'dclid',
      screen_resolution: 'sr',
      viewport_size: 'vp',
      screen_colors: 'sd',
      user_language: 'ul',
      java_enabled: 'je', # boolean
      flash_version: 'fl',
      # non_interactive: 'ni', # boolean
      document_location: 'dl',
      document_encoding: 'de', # duplicate of encoding
      document_hostname: 'dh', # duplicate of hostname
      document_path: 'dp', # duplicate of path
      document_title: 'dt', # duplicate of title
      link_id: 'linkid',
      application_name: 'an',
      application_version: 'av',
      experiment_id: 'xid',
      experiment_variant: 'xvar'
    }

    # sets up a new hit
    # @param tracker [Staccato::Tracker] the tracker to collect to
    # @param options [Hash] options for the specific hit type
    def initialize(tracker, options = {})
      self.tracker = tracker
      self.options = OptionSet.new(options)
    end

    # return the fields for this hit type
    # @return [Hash] the field definitions
    def fields
      self.class::FIELDS
    end

    # collects the parameters from options for this hit type
    def params
      base_params.
        merge(global_options_params).
        merge(hit_params).
        merge(custom_dimensions).
        merge(custom_metrics).
        reject {|_,v| v.nil?}
    end

    # is this a non interactive hit
    # @return [Integer, nil]
    def non_interactive
      1 if options[:non_interactive] # defaults to nil
    end

    def add_custom_dimension(position, value)
      self.custom_dimensions["cd#{position}"] = value
    end

    def custom_dimensions
      @custom_dimensions ||= {}
    end

    def add_custom_metric(position, value)
      self.custom_metrics["cm#{position}"] = value
    end

    def custom_metrics
      @custom_metrics ||= {}
    end

    def session_control
      case
      when options[:session_start], options[:start_session]
        'start'
      when options[:session_end], options[:end_session], options[:stop_session]
        'end'
      end
    end

    # post the hit to GA collection endpoint
    # @return [Net::HTTPOK] the GA api always returns 200 OK
    def track!
      post(Staccato.tracking_uri, params)
    end

    private
    # @private
    def post(uri, params = {})
      Net::HTTP.post_form(uri, params)
    end

    # @private
    def base_params
      {
        'v' => 1, # protocol version
        'tid' => tracker.id, # tracking/web_property id
        'cid' => tracker.client_id, # unique client id
        'ni' => non_interactive,
        'sc' => session_control,
        't' => type.to_s
      }
    end

    # @private
    def global_options_params
      Hash[
        options.map { |k,v| [GLOBAL_OPTIONS[k], v] if global_option?(k) }.compact
      ]
    end

    # @private
    def global_option?(key)
      GLOBAL_OPTIONS.keys.include?(key)
    end

    # @private
    def hit_params
      Hash[fields.map {|field,key| [key, options[field]]}]
    end
  end
end
