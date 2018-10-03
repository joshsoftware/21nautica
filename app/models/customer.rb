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
  has_many :ledgers

  validates_uniqueness_of :name, case_sensitive: false, message: "Customer with same name already exists"

  validates_format_of :emails, with: /\A^((\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)*([,])*|\s)*$\z/, on: :update
  before_save :strip_emails


  def add_default_emails_to_customer(customer)
    customer.emails = customer.emails + ", #{EMAILS_DEFAULTS}" 
    customer.emails.split(/,/).uniq.join(',')
  end

  def strip_emails
    self.emails = emails.strip! if emails
  end

end
