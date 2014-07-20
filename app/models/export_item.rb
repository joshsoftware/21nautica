# == Schema Information
#
# Table name: export_items
#
#  id          :integer          not null, primary key
#  container   :string(255)
#  location    :string(255)
#  weight      :string(255)
#  export_id   :integer
#  movement_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class ExportItem < ActiveRecord::Base

  belongs_to :export

  def as_json(options= {})
    super(only: [:id, :export_id, :container, :location], methods: [:date_of_placement])
  end

  def date_of_placement
    created_at.to_date.to_s
  end
end
