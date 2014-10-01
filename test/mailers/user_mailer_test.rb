require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  setup do
    @import = FactoryGirl.create :import
    @export = FactoryGirl.create :export
    @customer = FactoryGirl.create :customer
    @import.customer = @customer
    @export.customer = @customer
  end

  test "test welcome email" do
    email = UserMailer.welcome_message_import(@import).deliver
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal ['kaushik@21nautica.com'], email.from
    assert_equal ['cust1@gmail.com'], email.to
    assert_equal "Your new order", email.subject
  end

  test "test Import report mail" do
    email = UserMailer.mail_report(@customer,'import').deliver
    time = DateTime.parse(Time.now.to_s).strftime("%d_%b_%Y")
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal ['kaushik@21nautica.com'], email.from
    assert_equal ['cust1@gmail.com'], email.to
    assert_equal "Customer Update Cust1", email.subject
    assert_equal "Import_Cust1_#{time}.xlsx", email.attachments[0].filename
  end

  test "test Export report mail" do
    email = UserMailer.mail_report(@customer,'export').deliver
    time = DateTime.parse(Time.now.to_s).strftime("%d_%b_%Y")
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal ['kaushik@21nautica.com'], email.from
    assert_equal ['cust1@gmail.com'], email.to
    assert_equal "Customer Update Cust1", email.subject
    assert_equal "Export_Cust1_#{time}.xlsx", email.attachments[0].filename
  end

end