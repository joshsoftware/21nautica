class ExportItemsController < ApplicationController
  def create
    export = Export.find(params[:export_id])
    export.export_items.create(export_items_params)
    render nothing: :true
  end

  def update
    @export_item = ExportItem.find(export_items_params[:id])
    if @export_item.update_attributes!(export_items_params)
      export= Export.find(@export_item[:export_id])
      export_items= ExportItem.where(export_id: @export_item.export_id).where.not(container: nil)
      @e =export_items.count
      export[:placed]=@e
      @id = export.id
      export.save
    end
  end

  private
  def export_items_params
    params.permit(:container, :location, :date_of_placement, :export_id, :id)
  end
end