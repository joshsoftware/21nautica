require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  setup do
    @import = FactoryGirl.create :import
    @export = FactoryGirl.create :export
    @customer = FactoryGirl.create :customer, emails: 'cust1@gmail.com'
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
    assert_equal [@customer.emails, "kaushik@21nautica.com", "docs-ug@21nautica.com", "ops-ug@21nautica.com", "ops@21nautica.com", "Sales-ug@21nautica.com"], email.to
    assert_equal "Your new order", email.subject
  end

  test "test Import report mail" do
    @import_item1.import = @import
    @import_item2.import = @import
    @import.customer = @customer
    daily_report = Report::DailyImport.new
    daily_report.create(@customer)    
    @import.save!
    @import_item1.save!
    @import_item2.save!
    email = UserMailer.mail_report(@customer,'import').deliver
    time = DateTime.parse(Time.now.to_s).strftime("%d_%b_%Y")
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal ['kaushik@21nautica.com'], email.from
    assert_equal "Customer Update #{@import.customer.name}", email.subject
  end

  test "test Export report mail" do
    @export_item.export = @export
    @export_item1.export = @export
    @export_item.movement = @movement
    daily_report = Report::Daily.new
    daily_report.create(@customer)
    @export_item.save!
    @export_item1.save!
    @export.customer = @customer
    @export.save!
    email = UserMailer.mail_report(@customer,'export').deliver
    time = DateTime.parse(Time.now.to_s).strftime("%d_%b_%Y")
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal ['kaushik@21nautica.com'], email.from
    assert_equal "Customer Update #{@import.customer.name}", email.subject
  end

  test "late document mail" do
    email = UserMailer.late_document_mail(@import).deliver
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal ['kaushik@21nautica.com'], email.from
    assert_equal @import.customer.emails.split(","), email.to
    assert_equal "Late Document -BL Number #{@import.bl_number}", email.subject    
  end

  test "rotation number email" do
    @import.rotation_number = "1234"
    @import.save
    email = UserMailer.rotation_number_mail(@import).deliver()
    assert_equal ['kaushik@21nautica.com'], email.from
    assert_equal "Rotation Number for BL Number #{@import.bl_number}", email.subject
  end

end
