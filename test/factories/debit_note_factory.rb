FactoryGirl.define do
	factory :debit_note do
    reason 'test'
    amount 500 
    number 'A12345' 
    debit_note_for 'container'
    currency 'USD'

    association :bill
    association :vendor

    transient do
      vendor_ledger_count 1
    end

    #factory :debit_note_with_vendor_ledger do
    #  after(:create) do |debit_note, evaluator|
    #    create_list(:vendor_ledger_with_debit_note, evaluator.vendor_ledger_count, debit_note: debit_note)
    #  end
    #end

	end
end
