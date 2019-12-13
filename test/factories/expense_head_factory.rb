FactoryGirl.define do
  factory :expense_head do
    sequence(:name) { |name| "expense_head_#{Time.now.to_i} #{name}"}
    is_related_to_truck true
  end
end
