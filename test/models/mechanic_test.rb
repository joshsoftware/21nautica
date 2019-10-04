require 'test_helper'

class MechanicTest < ActiveSupport::TestCase
  setup do
    @mechanic = FactoryGirl.create :mechanic
  end

  test 'valid mechcanic' do
    assert @mechanic.valid?
  end

  test 'invalid without name' do
    @mechanic.name = nil
    refute @mechanic.valid?
    assert_not_nil @mechanic.errors[:name]
  end

  test 'invalid with same name' do
    mechanic = Mechanic.new
    mechanic.name = 'Prashant Bangar'
    assert_not mechanic.save
    assert mechanic.errors.messages[:name]
                   .include?('Mechanic with same name already exists')
  end
end
