class Ledger < ActiveRecord::Base
  belongs_to :customer
  belongs_to :voucher, polymorphic: true
end
