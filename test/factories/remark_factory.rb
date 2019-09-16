FactoryGirl.define do
  factory :remark, class: 'Remark' do
    date '2015-08-26' 
    desc "This is the test remark"
    remarkable_type "Import"
    remarkable_id (FactoryGirl.create :import).id
    category "internal"

  end
end
