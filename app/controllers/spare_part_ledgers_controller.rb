class SparePartLedgersController < ApplicationController

  def index
    @ledgers = SparePartLedger.where(spare_part_id: params[:spare_part_id]).order(date: :desc, id: :desc)
    json_data = {
                  :data => @ledgers,
                  :recordsTotal => @ledgers.count,
                  :recordsFiltered => @ledgers.count
                }
    respond_to do |format|
      format.html{}
      format.json { render json: json_data }
    end
  end

  def readjust
    spare_part = SparePart.where(parent_id:nil).find(params[:id])
    SparePartLedger.adjust_whole_ledger(spare_part)
    redirect_to spare_part_ledgers_path({spare_part_id: spare_part.id})
  end

  def new
    @spare_part_ledger = SparePartLedger.new
  end

  def create
    params[:is_adjustment] = true
    @spare_part_ledger = SparePartLedger.new(spare_part_ledger_params)
    if @spare_part_ledger.save
      puts "physical stock entry saved - #{@spare_part_ledger.spare_part_id}"
      @spare_part_ledger.adjust_physical_stock
      redirect_to spare_part_ledgers_path
    else
      render 'new'
    end
  end

  private

  def spare_part_ledger_params
    params.require(:spare_part_ledger).permit(:date, :inward_outward, :quantity, :spare_part_id, :is_adjustment)
  end

end