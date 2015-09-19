# == Schema Information
# Table name: debit_notes 
#
#  id            :integer      not null, primary key
#  bill_id       :integer
#  reason        :string
#  vendor_id     :integer
#  amount        :float
#
class DebitNote < ActiveRecord::Base
  belongs_to :bill
  belongs_to :vendor
end
