require 'test_helper'

class JobCardTest < ActiveSupport::TestCase
  setup do
    @job_card = FactoryGirl.create :job_card
  end
  test 'should save current date' do
    assert @job_card.save
    assert_equal Date.current, @job_card.date
  end
end
