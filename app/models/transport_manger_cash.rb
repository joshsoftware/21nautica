# Transport manger cash Model
class TransportMangerCash < ActiveRecord::Base
  validates :import_item_id, :transaction_amount, presence: true, if: -> { transaction_type.include?('Withdrawal') }
  validate :cash_assigned?, if: -> { transaction_date.nil? }
  before_save  :update_truck_id, :update_import_id, if: -> { transaction_type.include?('Withdrawal') }
  before_create :update_sr_number
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :import
  belongs_to :import_item
  belongs_to :truck

  def last_enrty_month
    TransportMangerCash.where('created_at >= ? ', Date.today.beginning_of_month)
                       .where.not(sr_number: nil).count
  end

  def update_sr_number
    self.sr_number = last_enrty_month + 1
  end

  def update_truck_id
    self.truck_id = import_item.truck.id
  end

  def update_import_id
    self.import_id = import_item.import_id
  end

  def last_available_balance
    TransportMangerCash.last.try(:available_balance).to_f
  end

  def cash_assigned?
    if TransportMangerCash.find_by(truck_id: import_item.truck.id, transaction_date: nil)
      errors.add(:import_item_id, 'truck has already assigned cash')
    end
  end
end
