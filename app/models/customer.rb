class Customer < ActiveRecord::Base
  has_many :order
end
