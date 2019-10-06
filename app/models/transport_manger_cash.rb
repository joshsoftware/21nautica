# Transport manger cash Model
class TransportMangerCash < ActiveRecord::Base
  before_create :update_sr_number, :update_import_item_id, :update_import_id, if: :truck_id?
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :import
  belongs_to :import_item
  belongs_to :truck
  validates :truck_id, :transaction_amount, presence: true, if: :truck_id?
  validate :cash_assigned?, if: :truck_id?

  def last_enrty_month
    TransportMangerCash.where('created_at >= ? ', Date.today.beginning_of_month)
                       .where.not(sr_number: nil).count
  end

  def update_sr_number
    self.sr_number = last_enrty_month + 1
  end

  def import_item
    ImportItem.find_by(truck_id: truck_id, status: 'truck_allocated')
  end

  def update_import_item_id
    self.import_item_id = import_item.id
  end

  def update_import_id
    self.import_id = import_item.import_id
  end

  def last_available_balance
    TransportMangerCash.last.try(:available_balance).to_f
  end

  def cash_assigned?
    if TransportMangerCash.find_by(truck_id: truck_id, transaction_date: nil)
      errors.add(:truck_id, 'truck has already  cash')
    end
  end
end
