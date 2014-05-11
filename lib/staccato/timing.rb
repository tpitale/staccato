module Staccato
  # Timing Hit type field definitions
  # @author Tony Pitale
  class Timing
    # Timing field definitions
    FIELDS = {
      category: 'utc',
      variable: 'utv',
      label: 'utl',
      time: 'utt',

      # more specific timings
      page_load_time: 'plt',
      dns_time: 'dns',
      page_download_time: 'pdt',
      redirect_response_time: 'rrt',
      tcp_connect_time: 'tcp',
      server_response_time: 'srt'
    }

    include Hit

    # timing hit type
    def type
      :timing
    end

    # tracks the timing hit type
    # @param block [#call] block is executed and time recorded
    def track!(&block)
      if block_given?
        start_at = Time.now
        block.call
        end_at = Time.now

        self.options.time = (end_at - start_at).to_i*1000
      end

      super
    end
  end
end
