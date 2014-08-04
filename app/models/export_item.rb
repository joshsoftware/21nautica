# == Schema Information
#
# Table name: export_items
#
#  id                :integer          not null, primary key
#  container         :string(255)
#  location          :string(255)
#  weight            :string(255)
#  export_id         :integer
#  movement_id       :integer
#  created_at        :datetime
#  updated_at        :datetime
#  date_of_placement :date
#

class ExportItem < ActiveRecord::Base
  belongs_to :export
  belongs_to :movement

  validates :date_of_placement, format: { with: /\d{4}-\d{1,2}-\d{1,2}/ }
  validate :date_of_placement_cannot_be_in_future

  def date_of_placement_cannot_be_in_future
    if date_of_placement.present? && date_of_placement >= Date.today
      errors.add(:date_of_placement, "Must be in the past")
    end
  end

  def as_json(options= {})
    super(only: [:id, :export_id, :container, :location, :date_of_placement,:movement_id])
  end

end
