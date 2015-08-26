class ImportExpense < ActiveRecord::Base
  belongs_to :import_item

  CATEGORIES = %w(Haulage Empty ICD Final\ Clearing Demurrage)
  CURRENCY = %w(USD UGX)

  def get_collection
    case self.category
      when 'Haulage'
        return [self.import_item.transporter_name]
      when 'Empty'
        return Vendor.transporters.order(:name).pluck(:name)
      when 'ICD'
        return %w(Maina Multiple)
      when 'Final Clearing'
        return Vendor.clearing_agents.order(:name).pluck(:name)
      when 'Demurrage'
        return [self.import_item.import.shipping_line.try(:name)]
    end
  end

  auditable only: [:name, :amount, :updated_at]

end
