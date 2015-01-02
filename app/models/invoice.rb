class Invoice < ActiveRecord::Base
  include AASM

  belongs_to :customer
  belongs_to :bill_of_lading
  delegate :bl_number, to: :bill_of_lading

  aasm column: 'status' do
    state :new, initial: true
    state :ready
    state :sent

    event :invoice_ready do
      transitions from: :new, to: :ready
    end

    event :invoice_sent do
      transitions from: :ready, to: :sent
    end
  end 

  def customer_name
    self.customer.name
  end

  def as_json(options={})
    super(methods: [:bl_number, :customer_name])
  end 

end
