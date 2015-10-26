class DebitNotesController < ApplicationController

  # Deleting the debit_notes and readjust the vendor ledger 
  #
  def delete_ledger
    debit_note = DebitNote.find(params[:id])
    vendor_id = debit_note.vendor_id
    debit_note.destroy

    redirect_to readjust_path(vendor_id)
  end

end
