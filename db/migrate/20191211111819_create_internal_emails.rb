class CreateInternalEmails < ActiveRecord::Migration
  def change
    create_table :internal_emails do |t|
      t.integer  :email_type
      t.string :emails
      t.timestamps
    end
  end
end
