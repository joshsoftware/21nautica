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
    self.create_ledger(amount: self.amount, customer: self.customer, date: self.date_of_payment)
    
    unpaid = Ledger.where(voucher_type: "Invoice", customer: self.customer).where("received < amount").order(date: :asc)

    money = self.amount
    unpaid.each do |inv|
      # return if money got over.
      return if money == 0

       # Expanding 1-liner logic to make the code readable.
       # (m - (a - r)) > 0 ? (m = (m - (a - r)); r = a) : (r = r + m; m = 0)
       if money - (inv.amount - inv.received) > 0
         # If surplus money left
         money -= inv.amount - inv.received
         inv.received = inv.amount
       else
         # If no surplus money
         inv.received = inv.received + money
         money = 0
       end

       inv.save
    end
  end
end
