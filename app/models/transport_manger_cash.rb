class TransportMangerCash < ActiveRecord::Base

  before_create :update_sr_number

  validates :truck_id, :transaction_amount, presence: true

  def last_enrty_month
    TransportMangerCash.where('created_at >= ? ', Date.today.beginning_of_month).count
  end
  
  def update_sr_number
    byebug
    self.sr_number = last_enrty_month + 1
  end

end
