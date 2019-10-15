class UserMailer < ActionMailer::Base
  default from: ENV['EMAIL_FROM']

  def mail_report(customer,type)
    @customer = customer
    emails = if ENV['HOSTNAME'] == 'RFS'
               customer.emails
             else
               customer.add_default_emails_to_customer
             end
    time = DateTime.parse(Time.now.to_s).strftime("%d_%b_%Y")
    if type == 'export'
      attachments["Export_#{customer.name.tr(" ", "_")}_#{time}.xlsx"] = File.read("#{Rails.root}/tmp/#{customer.name.tr(" ", "_")}_#{time}.xlsx")
    else
      attachments["Import_#{customer.name.tr(" ", "_")}_#{time}.xlsx"] = File.read("#{Rails.root}/tmp/Imports_#{customer.name.tr(" ", "_")}_#{time}.xlsx")
    end
    mail(to: emails, subject: "Customer Update #{customer.name}")
    type == 'export' ? File.delete("#{Rails.root}/tmp/#{customer.name.tr(" ", "_")}_#{time}.xlsx"):
      File.delete("#{Rails.root}/tmp/Imports_#{customer.name.tr(" ", "_")}_#{time}.xlsx")
  end

  def error_mail_report(customer, e)
    @customer = customer
    @exception = e
    mail(to: "paritoshbotre@joshsoftware.com", subject: "Error Report")
  end

  def send_emails_to_all_customer(customer)
    emails = customer.add_default_emails_to_customer
    mail(to: emails, subject: 'Our correct bank details')
  end

  def mail_report_status(type)
    attachments["daily_report.log"] = File.read("#{Rails.root}/tmp/daily_report.log")
    users = ["paritoshbotre@joshsoftware.com", "sameert@joshsoftware.com"]
    mail(to: users.join(", "), subject: "#{type} Report Status")
    File.delete("#{Rails.root}/tmp/daily_report.log")
  end

  def welcome_message_import(import, authority_letter_pdf = nil, authorisation_letter_pdf = nil)
    @import = import
    customer = Customer.find(@import.customer_id)
    emails = customer.add_default_emails_to_customer
    attach_pdf(authority_letter_pdf) if authority_letter_pdf
    attach_pdf(authorisation_letter_pdf) if authorisation_letter_pdf
    mail(to: emails, subject: "Your new order")
    File.delete("#{Rails.root}/tmp/#{File.basename authority_letter_pdf}") if authority_letter_pdf
    File.delete("#{Rails.root}/tmp/#{File.basename authorisation_letter_pdf}") if authorisation_letter_pdf
  end

  def attach_pdf(pdf)
    pdf_name = File.basename pdf
    attachment_name = pdf_name.gsub("#{@import.bl_number}_", '')
    attachments[attachment_name] = File.read(pdf)
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
    emails = invoice.customer.add_default_emails_to_customer
    mail(to: emails , subject: subject)
    File.delete(attachment)
  end

  def payment_received_receipt(customer, attachment)
    attachment_name = File.basename attachment
    attachments[attachment_name] = File.read(attachment)
    emails = customer.add_default_emails_to_customer
    mail(to: emails , subject: "Thank you for your payment")
    File.delete(attachment)
  end

  def late_document_mail(import)
    #this mail is triggered after saving the import and if import eta date is less than current date
    #nd also if bl_received_date is greater than eta date
    @import = import
    mail(to: import.customer.emails.split(","), subject: 'Late Document Mail')
  end

  def late_bl_received_mail(import)
    @import = import
    mail(to: import.customer.emails.split(","), subject: 'Late BL Received Mail')
  end

  def rotation_number_mail(import)
    @import = import
    mail(to: @import.customer.emails.split(","), subject: 'Rotation Number Mail')
  end

  def bl_entry_number_reminder(customer)
    @imports = customer.imports.where.not(:imports => {status: "ready_to_load"}).where("imports.bl_received_at IS NULL OR imports.entry_number IS NULL")
    mail(to: customer.emails.split(","), subject: "Pending Documents – #{Date.today.to_date.try(:to_formatted_s)}")
  end

end
