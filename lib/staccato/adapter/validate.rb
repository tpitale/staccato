module Staccato
  module Adapter
    class Validate
      def initialize(adapter = Staccato.default_adapter)
        @adapter = adapter.new URI('https://www.google-analytics.com/debug/collect')
      end

      def post(params)
        @adapter.post(params).body
      end
    end
  end
end
