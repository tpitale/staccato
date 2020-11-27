require 'thread'
require 'staccato/adapter/batch'


module Staccato
  module Adapter
    class ThreadBatch < Batch
      FLUSHING_TIMEOUT = 10

      def initialize(adapter=Staccato.default_adapter, size: DEFAULT_MAX_SIZE, flush_timeout: FLUSHING_TIMEOUT)
        super(adapter, size: size)
        @flushing_thread = Thread.new { loop { perform_flush; sleep(flush_timeout) } }
        @queue = SizedQueue.new(@size)
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
        post_body(param_array)
      end
    end
  end
end
