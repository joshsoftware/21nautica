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

  before_create :assign_emails

  def assign_emails
    self.emails = self.emails + ", accounts@21nautica.com, kaushik@21nautica.com, sachin@21nautica.com, docs@21nautica.com, docs-ug@21nautica.com, ops-ug@21nautica.com"
  end

end
