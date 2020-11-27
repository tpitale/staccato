module Staccato
  module Adapter
    class Batch
      BatchTooBigError = Class.new(StandardError)

      DEFAULT_MAX_SIZE = 20

      attr_reader :adapter

      def initialize(adapter=Staccato.default_adapter, size: DEFAULT_MAX_SIZE)
        validate_batch_size!(size)

        @size = size
        @adapter = adapter.new(Staccato.ga_batch_uri)
        @tracker_array = []
      end

      def validate_batch_size!(size)
        return if size <= DEFAULT_MAX_SIZE
        raise BatchTooBigError, "Batch size #{size} is larger than Google accepts."
      end

      def post(params)
        @tracker_array << params

        return if @tracker_array.size < @size

        post_body(@tracker_array)
        @tracker_array = []
      end

      private
      # convert our array of params hashes into a newline separated
      # form-encoded string for posting to GA's batch endpoint
      def batch_format(param_array=[])
        param_array.map {|params| URI.encode_www_form(params)}.join("\n")
      end

      def post_body(param_array)
        return if param_array.empty?
        # we may have to do something to format each as a new line when flushing
        @adapter.post_body(batch_format(param_array))
      end

    end
  end
end