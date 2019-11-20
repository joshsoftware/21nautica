class SparePartLedgersController < ApplicationController

  def index
    @ledgers = SparePartLedger.where(spare_part_id: params[:spare_part_id]).order(date: :desc)
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
    spare_part = SparePart.find(params[:id])
    SparePartLedger.adjust_whole_ledger(spare_part)
    redirect_to spare_part_ledgers_path({spare_part_id: spare_part.id})
  end

  def new
    @spare_part_ledger = SparePartLedger.new
  end

  def create
    
  end

end