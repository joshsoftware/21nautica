# frozen_string_literal: true

class RemarksController < ApplicationController
  before_action :set_model_instance

  def create
    @model_instance && @model_instance.remarks.create(desc: remarks_params[:desc], category: (remarks_params[:category] || "internal"))
  end

  def index
    if remarks_params[:model_type] == "import_item"
      render json: {
                    order_remarks: @model_instance.import.remarks.order(created_at: :desc),
                    container_remarks: @model_instance.remarks.order(created_at: :desc)
                   }
    else
      render json: {remarks: @model_instance.remarks.order(created_at: :desc)}
    end
  end

  private

  def remarks_params
    params.require(:remark).permit(:desc, :import_id, :category, :model_id, :model_type, :table)
  end

  def set_model_instance
    @model_instance = nil
    case remarks_params[:model_type]
    when "import"
      @model_instance = Import.find_by(id: remarks_params[:model_id])
    when "import_item"
      @model_instance = ImportItem.find_by(id: remarks_params[:model_id])
    when "local_import"
      @model_instance = LocalImport.find_by(id: remarks_params[:model_id])
    when "local_import_item"
      @model_instance = LocalImportItem.find_by(id: remarks_params[:model_id])
    end
  end
end
