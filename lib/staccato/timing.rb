module Staccato
  class Timing
    FIELDS = {
      category: 'utc',
      variable: 'utv',
      label: 'utl',
      time: 'utt'
    }

    include Hit

    def type
      :timing
    end

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
