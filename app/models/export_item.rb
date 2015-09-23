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

  # We need to validate only on :update, because we pre-create export-items
  # based on quantity
  validates :date_of_placement, format: { with: /\d{4}-\d{1,2}-\d{1,2}/, on: :update }
  validate :date_of_placement_cannot_be_in_future
  validate :assignment_of_container, if: "container.present? && container_changed?"
  validates_uniqueness_of :container

  def assignment_of_container
    count=0
    count1 = 0
    export_items=ExportItem.where(container: container)
    export_items.each do |item|
      if !item.movement.nil?
        count += 1 if item.movement.status != "container_handed_over_to_KPA"
      else
        count1 += 1
      end
    end
    if count > 0 || count1>0
      errors.add(:container,"#{container} is not free !")
    end
  end

  def date_of_placement_cannot_be_in_future
    if date_of_placement.present? && date_of_placement > Date.today
      errors.add(:date_of_placement, "Must be not be in the future")
    end
  end

  before_create do |record|
    record.date_of_placement = Date.today
  end

  def date_since_placement
    (Date.today - self.date_of_placement).to_i
  end

  def as_json(options= {})
    super(only: [:id, :export_id, :container, :location, :date_of_placement, :movement_id], methods: :date_since_placement)
  end

end
