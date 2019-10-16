# frozen_string_literal: true

class Remark < ActiveRecord::Base
  belongs_to :remarkable, polymorphic: true
  validates_presence_of :desc, :category
  validates_uniqueness_of :desc, scope: :remarkable_id #used for only executing the task
  enum category: ["internal", "external"]
  scope :internal, -> { where(category: 0).order(created_at: :desc) }
  scope :external, -> { where(category: 1).order(created_at: :desc) }

end
