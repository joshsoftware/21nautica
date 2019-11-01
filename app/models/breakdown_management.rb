# frozen_string_literal: true
class BreakdownManagement < ActiveRecord::Base
  belongs_to :truck
  belongs_to :breakdown_reason
  belongs_to :mechanic

  validates :truck_id, :date, :location, presence: true
  validates :sending_date, presence: true, if: -> { self.parts_required? }
  before_save :check_parts_required
  before_create :update_status
  scope :having_date_records, ->(start_date, end_date) { where(date: start_date..end_date)}
  def check_parts_required
    self.sending_date = parts_required ? sending_date : nil
  end

  def update_status
    self.status = 'Open'
  end
end
