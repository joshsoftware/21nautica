#Rails.logger.info "here ..."
module EspinitaPatch
			def audited_hash
				unless self.changes[:status]
					super.merge!( status: [self.status, self.status])
				else
					super
				end
			end
end


