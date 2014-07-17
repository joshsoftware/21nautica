# == Schema Information
#
# Table name: exports
#
#  id                   :integer          not null, primary key
#  equipment            :string(255)
#  quantity             :string(255)
#  export_type          :string(255)
#  shipping_line        :string(255)
#  placed               :integer
#  release_order_number :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

class Export < ActiveRecord::Base
  has_many :order_customers, as: :order
  has_many :customers, through: :order_customers

  TYPE = ['TBL', 'Haulage']
end
