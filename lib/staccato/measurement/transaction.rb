module Staccato
  module Measurement
    # Measurement class for transaction (non-hit data)
    class Transaction
      # lookup key for use in Hit#add_measurement
      # @return [Symbol]
      def self.lookup_key
        :transaction
      end

      # Transaction measurement options fields
      FIELDS = {
        transaction_id: 'ti',
        affiliation: 'ta',
        revenue: 'tr',
        shipping: 'ts',
        tax: 'tt',
        currency: 'cu',
        coupon_code: 'tcc'
      }.freeze

      include Measurable
    end
  end
end
