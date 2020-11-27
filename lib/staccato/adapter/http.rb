module Staccato
  module Adapter
    class HTTP # The Ruby HTTP Library Adapter
      def initialize(uri)
        @uri = uri
      end

      def post(params)
        ::HTTP.post(@uri, :form => params)
      end

      def post_body(data)
        ::HTTP.post(@uri, :body => data)
      end
    end
  end
end
