class RepairHead < ActiveRecord::Base
 validates :name, presence: true
 has_and_belongs_to_many :job_card_details
 scope :active, -> { where(:is_active => true)}
 validates_uniqueness_of :name, case_sensitive: false, message: 'Repair Head with same name already exists'
end
