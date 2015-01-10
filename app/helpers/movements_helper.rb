module MovementsHelper
  def status_updated_at(element)
    if (element.is_a?(ImportItem) && element.under_loading_process?)
      audit = import_item_loading_date(element)
    else
      audit = element.audits.select do |k|
        k[:audited_changes][:status].present? &&
        !(k[:audited_changes][:status].second.eql?(k[:audited_changes][:status].first)) and
             k[:audited_changes][:status].second == element.status
      end
    end
    audit.first.present? ? audit.first.audited_changes[:updated_at].second : "" 
  end

  def alert(updated_at, element)
    time = STATUS_CHANGE_DURATION[element.aasm.events.first.to_sym] * (24*60*60) 
    (Time.now - updated_at) > time 
  end

  def import_item_loading_date(element)
    element.import.audits.select do |audit_entry|
      audit_entry[:audited_changes][:status] == ["container_discharged", "ready_to_load"]
    end
  end
end
