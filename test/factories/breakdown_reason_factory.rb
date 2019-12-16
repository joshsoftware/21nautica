FactoryGirl.define do
  factory :breakdown_reason do
    sequence(:name) { |name| "Reason_#{Time.now.to_i} #{name}"}
  end
end
