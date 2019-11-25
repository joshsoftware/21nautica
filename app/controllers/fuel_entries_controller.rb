class FuelEntriesController < ApplicationController
  def index
    if params[:term].present?
      fuel_entries = FuelEntry.select("fuel_entries.*, trucks.reg_number truck_number")
                    .joins("left join trucks on trucks.id=fuel_entries.truck_id")
                    .where("trucks.reg_number ILIKE :term OR fuel_entries.office_vehicle ILIKE :term", term: "%#{params[:term]}%")
    else
      fuel_entries = FuelEntry.select("fuel_entries.*, trucks.reg_number truck_number").joins("left join trucks on trucks.id=fuel_entries.truck_id")
    end
    respond_to do |format|
      format.html {}
      format.json { render json: {"data" => fuel_entries.order(created_at: :desc).offset(params[:start]).limit(params[:length] || 10), "recordsTotal" => fuel_entries.count("fuel_entries.id"), "recordsFiltered" => fuel_entries.count("fuel_entries.id") } }
    end
  end

  def new
    @fuel_entry = FuelEntry.new
    @last_transaction_date = FuelEntry.order(:date).try(:first).try(:date)
    @trucks = Truck.where.not(reg_number: ["3rd Party Truck", "Co-Loaded Truck"]).order(:reg_number).pluck(:reg_number, :id)
  end

  def create
    @fuel_entry = FuelEntry.new(fuel_entry_params)
    if @fuel_entry.save
      if params[:fuel_entry][:purchased_dispensed].eql?('purchase')
        FuelStock.create(quantity: fuel_entry_params[:quantity],
                      rate: fuel_entry_params[:rate],
                      date: fuel_entry_params[:date])
        flash[:notice] = I18n.t 'fuel_entry.saved'
      end
      redirect_to :fuel_entries
    else
      @date = FuelEntry.last.try(:date).present? ? FuelEntry.last.date : Date.today - 1.year
      @trucks = Truck.alloted.pluck(:reg_number, :id)
      render 'new'
    end
  end

  private

  def fuel_entry_params
    params.require(:fuel_entry).permit(
      :date, :purchased_dispensed, :rate,
      :quantity, :is_adjustment, :truck_id,
      :office_vehicle
    )
  end
end
