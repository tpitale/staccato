require 'thread'

module Staccato
  module Adapter
    class Batch
      BatchTooBigError = Class.new(StandardError)

      DEFAULT_MAX_SIZE = 20

      def initialize(adapter=Staccato.default_adapter, size=DEFAULT_MAX_SIZE)
        raise BatchTooBigError.new("Batch size #{size} is larger than Google accepts.") if size > DEFAULT_MAX_SIZE

        @size = size
        @adapter = adapter.new(Staccato.ga_batch_uri)

        @queue = SizedQueue.new(@size)
        @flushing_thread = Thread.new { loop { flush } }
      end

      def post(params)
        # will block if the queue is full
        # while the flushing thread will continue to dequeue
        @queue << params
      end

      def clear
        # kills thread, flushes anything left in local array
        @flushing_thread.kill
        @flushing_thread.join # wait for killing to complete

        flush(true) # flush anything left in the queue
      end

      private
      # In a new thread collect params to a local array
      # when that array is at the batch size, POST to GA
      # then return and loop in the thread
      def flush(final=false)
        param_array = []

        while param_array.size < @size
          # thread-safe, sized queue
          # will block in this thread if nothing
          # is available to dequeue, unless final is true
          # then it is non_blocking, which raises a ThreadError
          param_array << @queue.deq(final)
        end
      rescue ThreadError
        # the queue is empty, breaks out of the while loop
        # only used for final flush
      ensure # this may catch a thread dying?
        # we may have to do something to format each as a new line when flushing
        @adapter.post(batch_format(param_array))
      end

      # convert our array of params hashes into a newline separated 
      # form-encoded string for posting to GA's batch endpoint
      def batch_format(param_array=[])
        param_array.map {|params| URI.encode_www_form(params)}.join("\n")
      end
    end
  end
end
