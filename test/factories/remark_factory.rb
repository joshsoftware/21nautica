FactoryGirl.define do
  factory :remark, class: 'Remark' do
    date '2015-08-26' 
    desc "This is the test remark"
    remarkable FactoryGirl.create :import
    category "internal"
  end
end
