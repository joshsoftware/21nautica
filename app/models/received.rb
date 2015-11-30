class Received < Payment
  belongs_to :customer
  validates_presence_of :customer_id

  has_one :ledger, as: :voucher, dependent: :destroy

  after_create do |record|
    record.update_ledger
  end

  # Update the ledger entry for this payment.
  # Then update the unpaid invoices for this customer (in full or partial)
  #  + Find unpaid invoices (Ledgers that have received < amount) sorted in ascending order by date
  #  + Start filling in the ledgers received amounts until the received payment gets exhausted. 
  def update_ledger
    self.create_ledger(amount: self.amount, customer: self.customer, date: self.date_of_payment, received: 0)
  end
end
