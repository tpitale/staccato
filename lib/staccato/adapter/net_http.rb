require 'net/http'

module Staccato
  module Adapter
    module Net
      class HTTP # The net/http Standard Library Adapter
        def initialize(uri)
          @uri = uri
        end

        def post(params)
          ::Net::HTTP.post_form(@uri, params)
        end

        def post_with_body(params, body)
          url = URI.parse([@uri, URI.encode_www_form(params)].join("?"))
          ::Net::HTTP.post(url, body)
        end
      end
    end
  end
end
