FactoryGirl.define do
  factory :vendor do
    name 'Mansons'
    vendor_type "transporter"

    transient do
      vendor_ledger_count 1
    end

    factory :vendor_with_vendor_ledgers do
      after(:create) do |vendor, evaluator|
        create_list(:vendor_ledger, evaluator.vendor_ledger_count, vendor: vendor)
      end
    end
  end
end
