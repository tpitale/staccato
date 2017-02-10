module Staccato
  module Adapter
    class Excon # The Excon Adapter
      attr_reader :uri

      def initialize(uri)
        @uri = uri
      end

      def post(params)
        ::Excon.post(uri.to_s,
                     body: URI.encode_www_form(params),
                     headers: { "Content-Type" => "application/x-www-form-urlencoded" })
      end
    end
  end
end
