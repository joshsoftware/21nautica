# frozen_string_literal: true

class AuditsController < ApplicationController
  def index
    if params[:searchValue].present?
      import_items = ImportItem.where("container_number ILIKE :query", query: "%#{params[:searchValue]}%").joins(:import)
    else
      import_items = ImportItem.none
    end
    respond_to do |format|
      format.html {}
      format.json {
        render json: {:data => import_items.offset(params[:start]).limit(params[:length] || 10).as_json,
                      "recordsTotal" => import_items.to_a.count, "recordsFiltered" => import_items.to_a.count}
      }
    end
  end

  def audits_modal
    @audits = Espinita::Audit.where(auditable_id: params[:id], auditable_type: 'ImportItem').all
  end
end