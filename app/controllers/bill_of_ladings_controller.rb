class BillOfLadingsController < ApplicationController
  # bill_of_ladings/search
  def search
    @bl = BillOfLading.where(bl_number: params[:id]).first
    @work_order_number = Import.where(bill_of_lading_id: @bl.id.to_s).first.try(&:work_order_number) ||
    Movement.where(bill_of_lading_id: @bl.id.to_s).first.try(&:w_o_number) unless @bl.nil?
    redirect_to :root, error: "WTF" and return unless @bl
  end

  # PUT/PATCH bill_of_ladings/:bl_number
  def update
    @bl = BillOfLading.find(params[:id])
    if @bl.update_attributes(bill_of_ladings_params)
      redirect_to :root
    else
      render :edit
    end
  end

  protected
  def bill_of_ladings_params
    params.require(:bill_of_lading).permit(:bl_number, :payment_ocean, :cheque_ocean,
                                           :shipping_line, :clearing_agent,
                                           :payment_clearing, :cheque_clearing, :remarks)
  end
end
