require 'logger'

module Staccato
  module Adapter
    class Logger # The Ruby HTTP Library Adapter
      DEFAULT_FORMATTER = lambda {|params| params.map {|k,v| [k,v].join('=')}.join(' ')}

      def initialize(uri, logger = nil, formatter = nil)
        @uri = uri

        @logger = logger || ::Logger.new(STDOUT)
        @formatter = formatter || default_formatter
      end

      def post(params)
        @logger.debug(@formatter.call(params))
      end

      def post_with_body(params, body)
        @logger.debug(@formatter.call(params))
        @logger.debug(@formatter.call(body))
      end

      private
      def default_formatter
        DEFAULT_FORMATTER
      end
    end
  end
end
