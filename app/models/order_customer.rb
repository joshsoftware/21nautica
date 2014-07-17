# == Schema Information
#
# Table name: order_customers
#
#  id          :integer          not null, primary key
#  order_id    :integer
#  order_type  :string(255)
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class OrderCustomer < ActiveRecord::Base
  belongs_to :order, polymorphic: true
  belongs_to :customer
end
