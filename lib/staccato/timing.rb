module Staccato
  # Timing Hit type field definitions
  # @author Tony Pitale
  class Timing
    # Timing field definitions
    FIELDS = {
      category: 'utc',
      variable: 'utv',
      label: 'utl',
      time: 'utt'
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
