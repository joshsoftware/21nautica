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

  def as_json(options= {})
    super(only: [:id, :export_id, :container, :location, :date_of_placement,:movement_id])
  end

end
