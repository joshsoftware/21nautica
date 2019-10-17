# Expense Head Module
class ExpenseHead < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 30 }
  scope :active, -> { where(:is_active => true) }
  has_many :petty_cashes
  validates_uniqueness_of :name, case_sensitive: false, message: "Expense Head with same name already exists"
  before_validation :strip_whitespaces, :only => [:name]

  private

    def strip_whitespaces
      self.name = self.name.strip.squish
    end
end
