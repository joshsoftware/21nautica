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
#  customer_id          :integer
#  created_at           :datetime
#  updated_at           :datetime
#

class Export < ActiveRecord::Base
  belongs_to :customer
  has_many :export_items

  TYPE = ['TBL', 'Haulage']
end
