class RepairHead < ActiveRecord::Base
 validates :name, presence: true
 scope :active, -> { where(:is_active => true)}
end
