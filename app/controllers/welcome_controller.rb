class WelcomeController < ApplicationController

  before_action :loaded_import_items_list, :arrived_at_border_list, :arrived_at_destination_list, :truck_allocated_list, :under_loading_list, :containers_awaiting_arrival_list

  def index
    @performance_stats = ImportItem.performance_stats
  end

  def client_wise_container_modal
    import_ids = Import.not_ready_to_load.custom_shipping_dates_not_present.ids
    if(params[:month].to_i == -1)
      client_wise_container_count = ImportItem.joins(import: :customer).where(import_id: import_ids).where.not(status: ["arrived_at_destination", "delivered"]).where("extract(month from imports.estimate_arrival)=? AND extract(year from imports.estimate_arrival)=?", (Date.today - 1.month).month, (Date.today - 1.month).year).group("customers.name").order('count_all desc').count
    elsif(params[:month].to_i == 1)
      client_wise_container_count = ImportItem.joins(import: :customer).where(import_id: import_ids).where.not(status: ["arrived_at_destination", "delivered"]).where("extract(month from imports.estimate_arrival)=? AND extract(year from imports.estimate_arrival)=?", (Date.today + 1.month).month, (Date.today + 1.month).year).group("customers.name").order('count_all desc').count
    else
      client_wise_container_count = ImportItem.joins(import: :customer).where(import_id: import_ids).where.not(status: ["arrived_at_destination", "delivered"]).where("extract(month from imports.estimate_arrival)=? AND extract(year from imports.estimate_arrival)=?", Date.today.month, Date.today.year).group("customers.name").order('count_all desc').count
    end
    @client_wise_container_count = client_wise_container_count
  end

  def containers_listing_modal
    if(params[:month].to_i == -1)
      containers_list = @last_month_under_loading_import_items.order("customers.name")
    elsif(params[:month].to_i == 1)
      containers_list = @next_month_under_loading_import_items.order("customers.name")
    else
      containers_list = @current_month_under_loading_import_items.order("customers.name")
    end
    @containers_list = containers_list
  end

  private

  def loaded_import_items_list
    @import_item_stats = []
    loaded_import_items = ImportItem.where(status: "loaded_out_of_port").joins("LEFT OUTER JOIN status_dates ON status_dates.import_item_id = import_items.id")
    @import_item_stats << ImportItem.stats(loaded_import_items,"loaded_out_of_port", "Loded out of Port")
  end

  def arrived_at_border_list
    arrived_at_border_import_items = ImportItem.where(status: "arrived_at_border").joins("LEFT OUTER JOIN status_dates ON status_dates.import_item_id = import_items.id")
    @import_item_stats << ImportItem.stats(arrived_at_border_import_items,"arrived_at_border", "Border")
  end

  def arrived_at_destination_list
    arrived_at_destination_import_items = ImportItem.where(status: "arrived_at_destination").joins("LEFT OUTER JOIN status_dates ON status_dates.import_item_id = import_items.id")
    @import_item_stats << ImportItem.stats(arrived_at_destination_import_items,"arrived_at_destination", "Destination")
  end

  def truck_allocated_list
    truck_allocated_import_items = ImportItem.where(status: "truck_allocated").joins("LEFT OUTER JOIN status_dates ON status_dates.import_item_id = import_items.id")
    ready_to_load_import_items = ImportItem.where(status: "ready_to_load").joins("LEFT OUTER JOIN status_dates ON status_dates.import_item_id = import_items.id")
    truck_allocated_stat = ImportItem.stats(truck_allocated_import_items,"truck_allocated", "Truck Allocated")
    ready_to_load_stat = ImportItem.stats(ready_to_load_import_items,"ready_to_load", "Ready to Load")
    @import_item_stats << { heading: truck_allocated_stat[:heading],
                          one: truck_allocated_stat[:one] + ready_to_load_stat[:one] ,
                          three: truck_allocated_stat[:three] + ready_to_load_stat[:three],
                          four: truck_allocated_stat[:four] + ready_to_load_stat[:four],
                          five: truck_allocated_stat[:five] + ready_to_load_stat[:five]}
  end

  def under_loading_list
    @last_month_under_loading_import_items = ImportItem.joins(import: :customer).where("imports.status='ready_to_load' OR (imports.bl_received_at IS NOT NULL AND imports.entry_number IS NOT NULL AND imports.entry_type IS NOT NULL)").where("import_items.status != 'delivered'").where(status:"under_loading_process").where("extract(month from imports.estimate_arrival)=? AND extract(year from imports.estimate_arrival)=?", (Date.today - 1.month).month, (Date.today - 1.month).year)
    @current_month_under_loading_import_items = ImportItem.joins(import: :customer).where("imports.status='ready_to_load' OR (imports.bl_received_at IS NOT NULL AND imports.entry_number IS NOT NULL AND imports.entry_type IS NOT NULL)").where("import_items.status != 'delivered'").where(status:"under_loading_process").where("extract(month from imports.estimate_arrival)=? AND extract(year from imports.estimate_arrival)=?", Date.today.month, Date.today.year)
    @next_month_under_loading_import_items = ImportItem.joins(import: :customer).where("imports.status='ready_to_load' OR (imports.bl_received_at IS NOT NULL AND imports.entry_number IS NOT NULL AND imports.entry_type IS NOT NULL)").where("import_items.status != 'delivered'").where(status:"under_loading_process").where("extract(month from imports.estimate_arrival)=? AND extract(year from imports.estimate_arrival)=?", (Date.today + 1.month).month, (Date.today + 1.month).year)
  end

  def containers_awaiting_arrival_list
    import_ids = Import.not_ready_to_load.custom_shipping_dates_not_present.ids
    @last_month_awaiting_arrivals = ImportItem.joins(:import).where(import_id: import_ids).where.not(status: ["arrived_at_destination", "delivered"]).where("extract(month from imports.estimate_arrival)=? AND extract(year from imports.estimate_arrival)=?", (Date.today - 1.month).month, (Date.today - 1.month).year)
    @current_month_awaiting_arrivals = ImportItem.joins(:import).where(import_id: import_ids).where.not(status: ["arrived_at_destination", "delivered"]).where("extract(month from imports.estimate_arrival)=? AND extract(year from imports.estimate_arrival)=?", Date.today.month, Date.today.year)
    @next_month_awaiting_arrivals = ImportItem.joins(:import).where(import_id: import_ids).where.not(status: ["arrived_at_destination", "delivered"]).where("extract(month from imports.estimate_arrival)=? AND extract(year from imports.estimate_arrival)=?", (Date.today + 1.month).month, (Date.today + 1.month).year)
  end
end
