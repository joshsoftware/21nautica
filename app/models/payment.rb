class Payment < ActiveRecord::Base
  include Remarkable
  
  validates_presence_of :amount
  validates_presence_of :date_of_payment
end
