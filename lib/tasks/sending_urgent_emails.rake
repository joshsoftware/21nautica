namespace "21nautica" do
  desc "Sending emails to all customers"
  task sending_emails: :environment do
    Customer.all.each do |customer|
      p "***** sending email to customer #{customer.name} ******"
      UserMailer.send_emails_to_all_customer(customer).deliver
    end
  end
end

