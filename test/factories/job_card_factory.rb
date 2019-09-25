FactoryGirl.define do
  factory :job_card, class: "JobCard" do
    number '1224'
    date '24/9/2019'
    association :truck, factory: :truck
    association :created_by, factory: :user
  end
  factory :job_card_detail, class: "JobCardDetail" do
    description 'Failed'
    association :repair_head, factory: :repair_head
    job_card
  end
end