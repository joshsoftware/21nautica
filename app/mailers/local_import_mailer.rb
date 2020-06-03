# frozen_string_literal: true

class LocalImportMailer < ActionMailer::Base
  default from: ENV["IDF_EMAIL_FROM"]
  default from: ["dec.nbo@reliablefreight.co.ke"] if Rails.env.development?

  def new_idf_email(local_import)
    @local_import = local_import
    customer = local_import.customer
    emails = customer.emails.to_s.split(",")
    mail(to: emails, subject: "New IDF Created: #{@local_import.idf_number}")
  end

  def new_order_email(local_import)
    @local_import = local_import
    customer = local_import.customer
    emails = customer.emails.to_s.split(",")
    mail(to: emails, subject: "Thank you for your Shipment : #{local_import.bl_number}")
  end

  def customs_entry_email(local_import)
    @local_import = local_import
    customer = local_import.customer
    emails = customer.emails.to_s.split(",")
    mail(to: emails, subject: "Customs Entry Generated for #{local_import.bl_number}")
  end

  def duty_paid_email(local_import)
    @local_import = local_import
    customer = local_import.customer
    emails = customer.emails.to_s.split(",")
    mail(to: emails, subject: "Duty Payment Confirmation for #{local_import.bl_number}")
  end

  def customer_summary_email(customer, filePath, fileName)
    @customer = customer
    emails = customer.emails.to_s.split(",")
    attachments[fileName] = File.read(filePath + fileName)
    if (File.exists?(file))
      mail(to: emails, subject: "Customer Update : #{customer.name}")
      File.delete(filePath + fileName)
    end
  end
end
