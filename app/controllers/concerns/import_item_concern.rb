module ImportItemConcern
  extend ActiveSupport::Concern

  def update_status
    if @import_item.truck_id.to_s != import_item_params[:truck_id]
      @import_item.status_date.update(truck_allocated: Date.today)
    end

    @import = @import_item.import
    initial_status = @import_item.status
    remark_params = params[:import_item]
    params[:import_item][:truck_number] = nil if params[:import_item][:truck_number].blank?
    @import_item.attributes = import_item_params.except('status')
    @import_item.remarks.create(desc: remark_params[:remarks], date: Date.today, category: "external") unless remark_params[:remarks].blank?
    status = import_item_params[:status].downcase.gsub(' ', '_')

    if @import_item.status == "under_loading_process" && @import_item.truck
      @import_item.allocate_truck
      @import_item.save
    elsif @import_item.status == "truck_allocated" && @import_item.exit_note_received
      if @import_item.import.entry_type == "wt8" && @import_item.expiry_date
        @import_item.ready_to_load
        @errors = @import_item.errors.full_messages
        @import_item.save
      elsif @import_item.import.entry_type == "im4"
        @import_item.ready_to_load
        @errors = @import_item.errors.full_messages
        @import_item.save
      else
        @import_item.save
      end
    else
      begin
        @import_item.send("#{status}!".to_sym) if status != @import_item.status
        @errors = @import_item.errors.full_messages
        @import_item.save
      rescue
        @errors = @import_item.errors.full_messages
        @import_item.save
      end
    end    
  end
end