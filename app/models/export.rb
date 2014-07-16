class Export < ActiveRecord::Base
  has_many :order_customers, as: :order
  has_many :customers, through: :order_customers

  TYPE = ['TBL', 'Haulage']
end
