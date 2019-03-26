require 'thread'

module Staccato
  module Adapter
    class Batch
      BatchTooBigError = Class.new(StandardError)

      DEFAULT_MAX_SIZE = 20
      FLUSHING_TIMEOUT = 10

      attr_reader :adapter

      def initialize(adapter=Staccato.default_adapter, size: DEFAULT_MAX_SIZE, flush_timeout: FLUSHING_TIMEOUT)
        if size > DEFAULT_MAX_SIZE
          raise BatchTooBigError, "Batch size #{size} is larger than Google accepts."
        end

        @size = size
        @adapter = adapter.new(Staccato.ga_batch_uri)

        @queue = SizedQueue.new(@size)
        @flushing_thread = Thread.new { loop { sleep(flush_timeout); perform_flush } }
      end

      def post(params)
        # will block if the queue is full
        # while the flushing thread will continue to dequeue

        @queue << params

        # Try to flush when we get to max queue size here
        @flushing_thread.wakeup if @queue.length >= @queue.max
      end

      def flush
        @flushing_thread.wakeup
      end

      def clear(final: false)
        if final
          # kills thread, flushes anything left in local array
          @flushing_thread.wakeup
          @flushing_thread.kill
          @flushing_thread.join # wait for killing to complete
        end

        perform_flush # flush anything left in the queue
      end

      private
      # In a new thread collect params to a local array
      # when that array is at the batch size, POST to GA
      # then return and loop in the thread
      def perform_flush
        param_array = []

        while param_array.size < @size
          # thread-safe, sized queue
          # avoid blocking, use non_blocking dequeue
          # this raises a ThreadError when it runs
          # out of elements in the queue
          param_array << @queue.deq(true)
        end
      rescue ThreadError
        # the queue is empty, breaks out of the while loop
      ensure
        unless param_array.empty?
          # we may have to do something to format each as a new line when flushing
          @adapter.post(batch_format(param_array))
        end
      end

      # convert our array of params hashes into a newline separated
      # form-encoded string for posting to GA's batch endpoint
      def batch_format(param_array=[])
        param_array.map {|params| URI.encode_www_form(params)}.join("\n")
      end
    end
  end
end
