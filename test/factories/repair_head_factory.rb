FactoryGirl.define do
  factory :repair_head, class: 'RepairHead' do
    sequence(:name) { |name| "repair_head_#{Time.now.to_i} #{name}"}
    is_active true
  end
end
