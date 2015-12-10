require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  setup do
    @invoice = FactoryGirl.create :invoice 
  end

  test 'should in new state when invoice is created' do
    assert_equal 'new', @invoice.status
  end

  test 'should update the status and create ledger' do
    @invoice.invoice_ready
    @invoice.invoice_sent
    assert_equal 'sent', @invoice.status
    assert @invoice.ledger
  end

  test 'should add particulars to invoice' do
    particular = FactoryGirl.create(:particular)
    particular.invoice = @invoice
    @invoice.particulars << particular
    assert_equal @invoice.particulars.first, particular
  end

  test 'it should add additional invoice' do
    additional_invoices = FactoryGirl.create(:invoice)
    @invoice.additional_invoices << additional_invoices 
    assert @invoice.additional_invoices
  end

end
