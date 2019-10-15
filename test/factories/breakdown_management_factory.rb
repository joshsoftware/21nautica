FactoryGirl.define do
  factory :breakdown_management do
    location 'Pune'
    date Date.today
    parts_required true
    sending_date Date.today
    status 'Open'
    remark 'hi'
    association :truck
    association :breakdown_reason
    association :mechanic
  end
end
