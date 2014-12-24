class RemoveParticipantsNameFromPayments < ActiveRecord::Migration
  def change
  	remove_column :payments, :participants_name, :string
  end
end
