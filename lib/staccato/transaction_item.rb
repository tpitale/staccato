module Staccato
  # Item Hit type field definitions for Transactions
  # @author Tony Pitale
  class TransactionItem
    # Item field definitions
    FIELDS = {
      transaction_id: 'ti',
      name: 'in',
      price: 'ip',
      quantity: 'iq',
      code: 'ic',
      variation: 'iv',
      currency: 'cu'
    }

    include Hit

    # item hit type
    def type
      :item
    end
  end
end
