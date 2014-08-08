module MovementsHelper
	def status_updated_at(element)
		audit = element.audits.select do |k| 
			k[:audited_changes][:status].present? && 
			k[:audited_changes][:status].second == element.status 
		end
		audit.first.present? ? audit.first.audited_changes[:updated_at].second : nil 
	end
end
