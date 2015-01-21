class ImportExpense < ActiveRecord::Base
  belongs_to :import_item
  after_update :update_import_invoice_amount

  CATEGORIES = %w(Haulage Empty ICD Final\ Clearing Demurrage)
  CURRENCY = %w(USD UGX)

  def get_collection
    case self.category
      when 'Haulage'
        return [self.import_item.transporter_name]
      when 'Empty'
        return Vendor.pluck(:name)
      when 'ICD'
        return %w(Maina Multiple)
      when 'Final Clearing'
        return CLEARING_AGENTS
      when 'Demurrage'
        return [self.import_item.import.shipping_line]
    end
  end

  auditable only: [:name, :amount, :updated_at]

  def update_import_invoice_amount
    bill_of_lading = self.import_item.import.bill_of_lading
    if bill_of_lading.invoice.present?
      invoice = bill_of_lading.invoice
      invoice.calulate_and_update_amount
    end
  end

end
