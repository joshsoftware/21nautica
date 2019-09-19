# frozen_string_literal: true

class RemarksController < ApplicationController
  before_action :set_model_instance

  def create
    @model_instance && @model_instance.remarks.create(desc: remarks_params[:desc], date: format_datetime, category: (remarks_params[:category] || "internal"))
  end

  def index
    render json: {internal: @model_instance.remarks.internal, external: @model_instance.remarks.external}
  end

  private

  def remarks_params
    params.require(:remark).permit(:desc, :date, :import_id, :category, :model_id, :model_type)
  end

  def set_model_instance
    @model_instance = nil
    case remarks_params[:model_type]
    when "import"
      @model_instance = Import.find_by(id: remarks_params[:model_id])
    when "import_item"
      @model_instance = ImportItem.find_by(id: remarks_params[:model_id])
    end
  end

  def format_datetime
    Time.zone.parse(remarks_params[:date] || Time.zone.now.to_s) + Time.zone.now.seconds_since_midnight.seconds
  end
end
