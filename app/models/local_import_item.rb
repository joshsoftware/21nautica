class LocalImportItem < ActiveRecord::Base
  belongs_to :local_import
  belongs_to :truck
  has_many :remarks, as: :remarkable
  validates_presence_of :container_number
  # validates_uniqueness_of :container_number
end
