class OrderCustomer < ActiveRecord::Base
  belongs_to :order, polymorphic: true
  belongs_to :customer
end
