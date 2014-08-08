module MovementsHelper
  def status_updated_at(element)
    audit = element.audits.select do |k| 
      k[:audited_changes][:status].present? && 
      k[:audited_changes][:status].second == element.status 
    end
    audit.first.present? ? audit.first.audited_changes[:updated_at].second : nil 
  end

  def time_in_seconds(time)
    seconds = time[0]*24*60*60 + time[1]*60*60 + time[2]*60 + time[3]
  end

  def alert(updated_at, element)
    time = time_in_seconds(STATUS_CHANGE_DURATION[element.aasm.events.first.to_sym])
    (Time.now - updated_at) > time  
  end

end
