class BreakdownManagement < ActiveRecord::Base
  belongs_to :truck
  belongs_to :breakdown_reason
  belongs_to :mechanic

  validates :truck_id, :date, :breakdown_reason_id, :location, presence: true
  validates :sending_date, presence: true, if: -> { parts_required? }
  before_save :check_parts_required 
  before_create :update_status
  
  def check_parts_required
    self.sending_date = parts_required ? sending_date : nil
  end

  def update_status
    self.status = 'Open'
  end
end
