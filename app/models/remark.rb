# frozen_string_literal: true

class Remark < ActiveRecord::Base
  belongs_to :remarkable, polymorphic: true
  validates_presence_of :desc, :category, :date
  enum category: ["internal", "external"]
  scope :internal, -> { where(category: 0).order(date: :desc) }
  scope :external, -> { where(category: 1).order(date: :desc) }
end
