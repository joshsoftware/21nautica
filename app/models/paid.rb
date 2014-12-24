class Paid < Payment
  belongs_to :vendor
  validates_presence_of :vendor_id
end