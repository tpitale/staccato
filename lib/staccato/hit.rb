module Staccato
  module Hit
    def self.included(model)
      model.extend Forwardable

      model.class_eval do
        attr_accessor :tracker, :options

        def_delegators :@options, *model::FIELDS.keys
      end
    end

    def initialize(tracker, options = {})
      self.tracker = tracker
      self.options = OptionSet.new(options)
    end

    def fields
      self.class::FIELDS
    end

    def params
      {
        'v' => 1,
        'tid' => tracker.id,
        'cid' => tracker.client_id,
        't' => type.to_s
      }.merge(Hash[
        fields.map {|field,key| [key, options[field]]}
      ]).reject {|_,v| v.nil?}
    end

    def track!
      post(Staccato.tracking_uri, params)
    end

    def post(uri, params = {})
      Net::HTTP.post_form(uri, params)
    end
  end
end
