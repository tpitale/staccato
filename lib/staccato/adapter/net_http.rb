require 'net/http'

module Staccato
  module Adapter
    module Net
      class HTTP # The net/http Standard Library Adapter
        def initialize(uri, proxy_host: nil, proxy_port: nil)
          @uri = uri
          @proxy_host = proxy_host
          @proxy_port = proxy_port
        end

        def post(params)
          if @proxy_host.present?
            ::Net::HTTP.Proxy(@proxy_host, @proxy_port).post_form(@uri, params)
          else
            ::Net::HTTP.post_form(@uri, params)
          end
        end
      end
    end
  end
end
