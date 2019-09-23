class RepairHead < ActiveRecord::Base
 validates :name, presence: true
 has_and_belongs_to_many :job_card_details
 scope :active, -> { where(:is_active => true)}
end
