class UserMailer < ActionMailer::Base
  default from: "Kaushik Somanathan<kaushik@21nautica.com>"

  def mail_report(customer,type)
    @customer = customer
    emails = customer.add_default_emails_to_customer(@customer)
    @customer.emails = emails
    time = DateTime.parse(Time.now.to_s).strftime("%d_%b_%Y")
    if type == 'export'
      attachments["Export_#{customer.name.tr(" ", "_")}_#{time}.xlsx"] = File.read("#{Rails.root}/tmp/#{customer.name.tr(" ", "_")}_#{time}.xlsx")
    else
      attachments["Import_#{customer.name.tr(" ", "_")}_#{time}.xlsx"] = File.read("#{Rails.root}/tmp/Imports_#{customer.name.tr(" ", "_")}_#{time}.xlsx")
    end
    mail(to: @customer.emails, subject: "Customer Update #{customer.name}")
    type == 'export' ? File.delete("#{Rails.root}/tmp/#{customer.name.tr(" ", "_")}_#{time}.xlsx"):
      File.delete("#{Rails.root}/tmp/Imports_#{customer.name.tr(" ", "_")}_#{time}.xlsx")
  end

  def error_mail_report(customer, e)
    @customer = customer
    @exception = e
    mail(to: "paritoshbotre@joshsoftware.com", subject: "Error Report")
  end

  def send_emails_to_all_customer(customer)
    emails = customer.add_default_emails_to_customer(customer)
    mail(to: emails, subject: 'Urgent Emails')
  end

  def mail_report_status(type)
    attachments["daily_report.log"] = File.read("#{Rails.root}/tmp/daily_report.log")
    users = ["paritoshbotre@joshsoftware.com", "sameert@joshsoftware.com"]
    mail(to: users.join(", "), subject: "#{type} Report Status")
    File.delete("#{Rails.root}/tmp/daily_report.log")
  end

  def welcome_message_import(import)
    @import = import
    customer = Customer.find(@import.customer_id)
    emails = customer.add_default_emails_to_customer(customer)
    customer.emails = emails
    mail(to: customer.emails,subject: "Your new order")
  end

  def mail_expense_report(type)
    @type = type
    time = DateTime.parse(Time.now.to_s).strftime("%d_%b_%Y")
    attachments["Expense_#{@type}_#{time}.xlsx"] = File.read("#{Rails.root}/tmp/Expense_#{@type}_#{time}.xlsx")
    mail(to: "kaushik@21nautica.com, rajan@21nautica.com" ,subject: "Expense #{@type}")
    File.delete("#{Rails.root}/tmp/Expense_#{@type}_#{time}.xlsx")
  end

  def mail_invoice(invoice, attachment)
    attachment_name = File.basename attachment
    attachments[attachment_name] = File.read(attachment)
    subject = "Invoice // #{invoice.customer_name} // #{invoice.bl_number} // #{invoice.number}"
    emails = invoice.customer.add_default_emails_to_customer(invoice.customer)
    invoice.customer.emails = emails
    mail(to: invoice.customer.emails , subject: subject)
    File.delete(attachment)
  end

  def payment_received_receipt(customer, attachment)
    attachment_name = File.basename attachment
    attachments[attachment_name] = File.read(attachment)
    emails = customer.add_default_emails_to_customer(customer)
    customer.emails = emails
    mail(to: customer.emails , subject: "Thank you for your payment")
    File.delete(attachment)
  end

end
