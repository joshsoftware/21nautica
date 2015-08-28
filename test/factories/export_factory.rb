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

FactoryGirl.define do
  
  factory :export do
    equipment '20'
    quantity  '20'
    release_order_number '12345678'
    export_type 'TBL'
  end
end

