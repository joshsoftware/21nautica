# frozen_string_literal: true

class Remark < ActiveRecord::Base
  belongs_to :remarkable, polymorphic: true
  validates_presence_of :desc, :category
  enum category: ["internal", "external"]
  scope :internal, -> { where(category: 0).order(created_at: :desc) }
  scope :external, -> { where(category: 1).order(created_at: :desc) }

  before_create :add_date

  def add_date
    self.date = DateTime.now
  end
end
