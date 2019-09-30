# Job card Detail model
class JobCardDetail < ActiveRecord::Base
  belongs_to :job_card
  belongs_to :repair_head
end
