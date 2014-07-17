class Customer < ActiveRecord::Base
  has_many :order_customers
  has_many :exports, through: :order_customers, source: :order, source_type: "Export"
  has_many :imports, through: :order_customers, source: :order, source_type: "Import"
end
