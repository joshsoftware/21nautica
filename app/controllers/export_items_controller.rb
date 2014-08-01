class ExportItemsController < ApplicationController
  
  def create
    export = Export.find(params[:export_id])
    export.export_items.create(export_items_params)
    render nothing: :true
  end

  def update
    export = ExportItem.find(export_items_params[:id])
    export.update_attributes(export_items_params)
    render nothing: true
  end

  private
  def export_items_params
    params.permit(:container, :location, :date_of_placement, :export_id, :id)
  end
end
