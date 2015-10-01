class AddCurrencyToDebitNote < ActiveRecord::Migration
  def change
    add_column :debit_notes, :currency, :string
  end
end
