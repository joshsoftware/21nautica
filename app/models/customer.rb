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
  has_many :exports
  has_many :imports
  has_many :invoices
  has_many :payments
end
