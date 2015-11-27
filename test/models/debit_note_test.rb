require 'test_helper'

class DebitNoteTest < ActiveSupport::TestCase
  setup do
    @bill = FactoryGirl.create :bill_with_debit_note
    @debit_note = FactoryGirl.create :debit_note
  end

  test 'should belongs to bill' do
    debit_note = @bill.reload.debit_notes.last
    assert_equal debit_note.bill, @bill 
    assert_equal 1, @bill.debit_notes.count 
  end

  test 'should create vendor ledger debit note' do
    assert @debit_note.vendor_ledger
    assert_equal @debit_note.vendor_ledger.vendor_id, @debit_note.vendor_id
    assert_equal @debit_note.vendor_ledger.amount, @debit_note.amount
  end
end
