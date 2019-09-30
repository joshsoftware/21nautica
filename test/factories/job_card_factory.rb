FactoryGirl.define do
  factory :job_card, class: 'JobCard' do
    number '1224'
    date '24/9/2019'
    after(:build) { |jd|
      jd.job_card_details << FactoryGirl.build(:job_card_detail)
    }
    after(:save) { |jd|
      jd.job_card_details.each { |jds| jds.save! }
    }
    association :truck, factory: :truck
    association :created_by, factory: :user
  end
end
