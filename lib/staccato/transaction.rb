module Staccato
  class Transaction
    FIELDS = {
      transaction_id: 'ti',
      affiliation: 'ta',
      revenue: 'tr',
      shipping: 'ts',
      tax: 'tt',
      currency: 'cu'
    }

    include Hit

    def type
      :transaction
    end
  end
end