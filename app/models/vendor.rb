class Vendor < ActiveRecord::Base
  has_many :payments
end
