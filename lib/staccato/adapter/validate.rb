module Staccato
  module Adapter
    class Validate
      def initialize(adapter = Staccato.default_adapter, validation_url = 'https://www.google-analytics.com/debug/collect')
        @adapter = adapter.new URI(validation_url)
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
