# Job card model
class JobCard < ActiveRecord::Base
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :truck
  has_many :job_card_details
  accepts_nested_attributes_for :job_card_details, allow_destroy: true
  before_create :update_date

  def update_date
    self.date = Date.current.strftime('%d-%m-%Y')
  end
end
