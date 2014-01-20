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
      base_params.merge(global_options_params).merge(hit_params).reject {|_,v| v.nil?}
    end

    # is this a non interactive hit
    # @return [Integer, nil]
    def non_interactive
      1 if options[:non_interactive] # defaults to nil
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
        'v' => 1,
        'tid' => tracker.id,
        'cid' => tracker.client_id,
        'ni' => non_interactive,
        't' => type.to_s
      }
    end

    # @private
    def global_options_params
      {
        'dr' => options[:referrer],
        'de' => options[:encoding],
        'ul' => options[:user_language],
        'ni' => non_interactive,
        'xid' => options[:experiment_id],
        'xvar' => options[:experiment_variant]
      }
    end

    # @private
    def hit_params
      Hash[fields.map {|field,key| [key, options[field]]}]
    end
  end
end
