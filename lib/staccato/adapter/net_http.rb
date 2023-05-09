require 'net/http'

module Staccato
  module Adapter
    module Net
      # The net/http Standard Library Adapter
      class HTTP

        attr_reader :uri

        def initialize(uri)
          @uri = uri
        end

        def post(params)
          ::Net::HTTP.post_form(@uri, params)
        end

        def post_with_body(params, body)
          uri = [@uri, URI.encode_www_form(params)].join('?')
          ::Net::HTTP.post(URI.parse(uri), body)
        end
      end
    end
  end
end
