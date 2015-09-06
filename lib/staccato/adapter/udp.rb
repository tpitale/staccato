require 'uri'
require 'socket'

module Staccato
  module Adapter
    class UDP
      # Takes a URI with host/port
      #   e.g.: URI('udp://127.0.0.1:3001')
      def initialize(uri)
        @host = uri.host
        @port = uri.port

        @socket = UDPSocket.new
      end

      def post(params)
        body = URI.encode_www_form(params)

        @socket.send(body, 0, @host, @port)
      end
    end
  end
end
