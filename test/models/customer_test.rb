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

require 'test_helper'

class CustomerTest < ActiveSupport::TestCase

  setup do
    @customer = FactoryGirl.create :customer, name: 'Paritosh', emails: 'paritoshbotre@joshsoftware.com'
  end

  test 'should not create customer with same name' do
    customer = Customer.new
    customer.name = 'Paritosh'
    customer.emails = 'abc@gmail.com'
    assert_not customer.save
    assert customer.errors.messages[:name].include?('Customer with same name already exists')
  end

  test 'should validate the format of email on update' do
    @customer.emails = 'paritosh@josh'
    assert_not @customer.save
  end

  test 'should add default emails to customer' do
    customer = @customer
    customer.add_default_emails_to_customer(customer)
    assert customer.emails, 'paritoshbotre@joshsoftware.com, accounts@21nautica.com, kaushik@21nautica.com, 
    sachin@21nautica.com, docs@21nautica.com, docs-ug@21nautica.com, ops-ug@21nautica.com, chetan@21nautica.com, ops@21nautica.com '
  end

end
