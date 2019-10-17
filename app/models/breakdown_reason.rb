# frozen_string_literal: true

class BreakdownReason < ActiveRecord::Base
  has_many  :breakdown_managements
  validates_presence_of :name, message: "Name can't be blank"
  validates_uniqueness_of :name, case_sensitive: false, message: "Reason is already present"
  before_validation :strip_whitespaces

  def strip_whitespaces
    self.name = name.strip.squish if name.present?
  end
end
