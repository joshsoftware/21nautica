FactoryGirl.define do
  factory :job_card_detail, class: 'JobCardDetail' do
    description 'failed'
    association :repair_head, factory: :repair_head
  end
end
