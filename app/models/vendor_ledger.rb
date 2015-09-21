class VendorLedger < ActiveRecord::Base
  belongs_to :vendor
  belongs_to :voucher, polymorphic: true
end
