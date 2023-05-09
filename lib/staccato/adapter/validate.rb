module Staccato
  module Adapter
    class Validate
      VALIDATION_URI = URI('https://www.google-analytics.com/debug/collect')
        .freeze

      attr_reader :adapter

      def uri; adapter.uri end

      def initialize(klass = Staccato.default_adapter, uri = VALIDATION_URI)
        @adapter = klass.new uri
      end

      def post(params)
        @adapter.post(params).body
      end

      def post_with_body(params, body)
        @adapter.post_with_body(params, body).body
      end
    end
  end
end
