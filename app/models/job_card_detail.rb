class JobCardDetail < ActiveRecord::Base
  belongs_to :job_card, class_name: "job_card", foreign_key: "job_card_id"
  belongs_to :repair_head

end
