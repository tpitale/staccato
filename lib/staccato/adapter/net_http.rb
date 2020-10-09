# frozen_string_literal: true

require 'net/http'

module Staccato
  module Adapter
    module Net
      # The net/http Standard Library Adapter
      class HTTP
        def initialize(uri)
          @uri = uri
        end

        def post(params)
          ::Net::HTTP.post_form(@uri, params)
        end

        def post_body(data)
          ::Net::HTTP.post(@uri, data)
        end
      end
    end
  end
end
