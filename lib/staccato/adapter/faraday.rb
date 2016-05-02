require 'faraday'

module Staccato
  module Adapter
    class Faraday # The Faraday Adapter
      def initialize(uri)
        @connection = ::Faraday.new(uri) do |faraday|
          faraday.request  :url_encoded             # form-encode POST params
          faraday.adapter  ::Faraday.default_adapter  # make requests with Net::HTTP

          yield faraday if block_given?
        end
      end

      def post(params)
        @connection.post(nil, params)
      end
    end
  end
end
