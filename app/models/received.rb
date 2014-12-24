class Received < Payment
  belongs_to :customer
  validates_presence_of :customer_id
end