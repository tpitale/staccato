module Staccato
  # Transaction Hit type field definitions
  # @author Tony Pitale
  class Transaction
    # Transaction field definitions
    FIELDS = {
      transaction_id: 'ti',
      affiliation: 'ta',
      revenue: 'tr',
      shipping: 'ts',
      tax: 'tt',
      currency: 'cu'
    }

    include Hit

    # transaction hit type
    def type
      :transaction
    end
  end
end
