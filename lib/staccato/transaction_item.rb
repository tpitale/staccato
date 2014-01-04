module Staccato
  class TransactionItem
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

    def type
      :item
    end
  end
end
