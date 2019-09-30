FactoryGirl.define do
  factory :repair_head, class: 'RepairHead' do
    name 'star'+Time.now.to_s
    is_active true
  end
end
