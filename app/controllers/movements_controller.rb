class MovementsController < ApplicationController

  def index
    @movements = Movement.where.not(status: "container_handed_over_to_KPA").order(:booking_number)
    @show_update = true
    @transporters = TRANSPORTERS.inject({}) {|h, x| h[x] = x; h }
    @destination_ports = DESTINATION_PORTS.inject({}) {|h, x| h[x] = x; h }
  end

  def history
    @movements = Movement.where(status: "container_handed_over_to_KPA").order(:booking_number)
    @transporters = TRANSPORTERS.inject({}) {|h, x| h[x] = x; h }
    @destination_ports = DESTINATION_PORTS.inject({}) {|h, x| h[x] = x; h }
  end

  # JS call.
  def create
    movement = Movement.new(movement_params)
    @export_item = ExportItem.find(params[:export_item_id])
    export = @export_item.export
    movement.shipping_seal = @export_item.export.shipping_line
    movement.movement_type = @export_item.export.export_type
    if movement.save
      @export_item.movement_id = movement.id
      @export_item.save
      @moved_count = @export_item.export.export_items.where.not(movement_id: nil).count
      export_items = export.export_items.where(movement_id: nil).where.not(container: ['', nil])
      @count = export_items.count
      export[:placed] = @count
      export[:moved] = @moved_count
      @id = export.id
      export.save
    else
      @error = movement.errors.full_messages
    end
    render 'new'
  end

  def new
    @movement=Movement.new
  end

  def update
    movement = Movement.find(movement_update_params[:id])
    attribute = movement_update_params[:columnName].downcase.gsub(' ', '_').to_sym

    # Special processing for bl_number
    if attribute == :bl_number
      # If no BL of this value, then create one.
      bl = BillOfLading.where(bl_number: movement_update_params[:value]).first
      if bl
        movement.bill_of_lading = bl
      else
        movement.build_bill_of_lading(bl_number: movement_update_params[:value])
      end

      # update the movement
      if movement.save
        render text: movement_update_params[:value]
      else
        render movement.errors.full_messages
      end
    else
      if movement.update(attribute => movement_update_params[:value])
        render text: movement_update_params[:value]
      else
        render text: movement.errors.full_messages
      end
    end
  end

  def updateStatus
    @movement = Movement.find(params[:id])
    @movement.remarks = movement_params[:remarks]
    @movement.booking_number = movement_params[:booking_number]
    @movement.vessel_targeted = movement_params[:vessel_targeted]
    status = movement_params[:status].downcase.gsub(' ', '_')
    status != @movement.status ? @movement.send("#{status}!".to_sym) : @movement.save
  end
  def retainStatus
    @movement = Movement.find(params[:id])
  end

  private

  def movement_update_params
    params.permit(:id, :columnName, :value)
  end

  def movement_params
    params.permit(:export_item_id, :id)
    params.require(:movement).permit(:booking_number, :truck_number, :vessel_targeted,
                   :remarks, :status, :port_of_discharge, :movement_type, :transporter_name)
  end

end
