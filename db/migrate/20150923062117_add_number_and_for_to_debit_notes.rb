class AddNumberAndForToDebitNotes < ActiveRecord::Migration
  def change
    add_column :debit_notes, :number, :text
    add_column :debit_notes, :debit_note_for, :string
  end
end
