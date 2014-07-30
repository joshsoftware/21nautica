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
  EQUIPMENT_TYPE =['20GP','40GP','40OT','40FR','20OT']
  SHIPPING_LINE =['CMA CGM','Maersk','Evergreen','Safmarine','PIL']

end
