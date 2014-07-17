# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  emails     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Customer < ActiveRecord::Base
  has_many :order_customers
  has_many :exports, through: :order_customers, source: :order, source_type: "Export"
  has_many :imports, through: :order_customers, source: :order, source_type: "Import"
end
