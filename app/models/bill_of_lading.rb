class BillOfLading < ActiveRecord::Base
  validates_uniqueness_of :bl_number
  auditable only: [:payment_ocean, :cheque_ocean,
    :payment_clearing, :cheque_clearing, :updated_at]
  
  def is_export_bl?
    Import.where(bill_of_lading_id: self.id.to_s).blank?
  end
end
