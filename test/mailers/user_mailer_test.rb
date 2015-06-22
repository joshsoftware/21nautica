require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  setup do
    @import = FactoryGirl.create :import
    @export = FactoryGirl.create :export
    @customer = FactoryGirl.create :customer
    @export_item = FactoryGirl.create :export_item
    @export_item1 = FactoryGirl.create :export_item1
    @import_item1 = FactoryGirl.create :import_item1
    @import_item2 = FactoryGirl.create :import_item2
    @movement = FactoryGirl.create :movement
    @import.customer = @customer
  end

  test "test welcome email" do
    email = UserMailer.welcome_message_import(@import).deliver
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal ['kaushik@21nautica.com'], email.from
    assert_equal ["cust1@gmail.com", "accounts@21nautica.com", "kaushik@21nautica.com",
        "sachin@21nautica.com", "docs@21nautica.com", "docs-ug@21nautica.com", "ops-ug@21nautica.com", "chetan@21nautica.com"], email.to
    assert_equal "Your new order", email.subject
  end

  test "test Import report mail" do
    @import_item1.import = @import
    @import_item2.import = @import
    @import.customer = @customer
    @import.remarks = "remark2"
    @import.save!
    @import_item1.save!
    @import_item2.save!
    email = UserMailer.mail_report(@customer,'import').deliver
    time = DateTime.parse(Time.now.to_s).strftime("%d_%b_%Y")
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal ['kaushik@21nautica.com'], email.from
    assert_equal ["cust1@gmail.com", "accounts@21nautica.com", "kaushik@21nautica.com",
        "sachin@21nautica.com", "docs@21nautica.com", "docs-ug@21nautica.com", 
        "ops-ug@21nautica.com", "chetan@21nautica.com"], email.to
    assert_equal "Customer Update #{@import.customer.name}", email.subject
  end

  test "test Export report mail" do
    @export_item.export = @export
    @export_item1.export = @export
    @export_item.movement = @movement
    @export_item.save!
    @export_item1.save!
    @export.customer = @customer
    @export.save!
    email = UserMailer.mail_report(@customer,'export').deliver
    time = DateTime.parse(Time.now.to_s).strftime("%d_%b_%Y")
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal ['kaushik@21nautica.com'], email.from
    assert_equal ["cust1@gmail.com", "accounts@21nautica.com", "kaushik@21nautica.com",
        "sachin@21nautica.com", "docs@21nautica.com", "docs-ug@21nautica.com", 
        "ops-ug@21nautica.com", "chetan@21nautica.com"], email.to
    assert_equal "Customer Update #{@import.customer.name}", email.subject
  end

end
