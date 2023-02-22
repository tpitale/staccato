module Staccato
  module Adapter
    class Validate
      def initialize(adapter = Staccato.default_adapter)
        @adapter = adapter.new URI('https://www.google-analytics.com/debug/collect')
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
