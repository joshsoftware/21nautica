module InternalEmailsHelper

  def internal_emails
    existing_emails = InternalEmail.all.map(&:email_type).uniq
    internal_emails = InternalEmail.email_types.map{|s| s[0]}
    (internal_emails-existing_emails).map{ |type| [type, type]}
  end

end
