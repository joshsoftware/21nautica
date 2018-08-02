class ReqSheet < ActiveRecord::Base
  has_many :req_parts, dependent: :destroy

  validates_presence_of :ref_number, :date

  accepts_nested_attributes_for :req_parts, allow_destroy: true
end
