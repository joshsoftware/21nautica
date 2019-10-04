# Mechanic Master Model
class Mechanic < ActiveRecord::Base
  belongs_to :created_by, class_name: 'User', foreign_key: "created_by_id"
  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false, message: 'Mechanic with same name already exists'
end
