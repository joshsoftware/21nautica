class ImportExpense < ActiveRecord::Base
  CATEGORIES = %w(Haulage Empty ICD Final\ Clearing Demurrage)
  CURRENCY = %w(USD UGX)
end
