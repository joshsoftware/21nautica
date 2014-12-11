class ImportExpensesController < ApplicationController
  def index
    @import_items = ImportItem.where("container_number like ?", "%#{import_expense_params[:id]}%")

    # In case, the bl_number has also been provided, use it (secondary search)
    if params[:bl_number]
      # There can be only 1 unique combination of import_item and BL number
      @import_items = @import_items.select { |i| i.bl_number == import_expense_params[:bl_number] }
    end

    # if there are multiple @import_items, then it means the container has been reused. 
    # In that case we need to show  dropdown for their BL numbers.
    if @import_items.count > 1
      @bl_numbers = @import_items.collect(&:bl_number) 
    elsif @import_items.count == 1
      # If there's only 1, redirect
      redirect_to edit_import_item_import_expense_path(@import_items.first)
    else
      # no such container
      redirect_to root_path, error:  "No such container"
    end
  end

  def edit
    @import_item = ImportItem.find(import_expense_params[:import_item_id])
  end

  def update
    @import_item = ImportItem.find(import_expense_params[:import_item_id])
    @import_item.update_attributes!(import_expense_update_params)
    redirect_to :root
  end

  private

  def import_expense_params
    params.permit(:id, :bl_number, :import_item_id)
  end

  def import_expense_update_params
    params.require(:import_item).permit(:import_expenses_attributes => [:category, :currency, 
      :invoice_date, :invoice_number, :delivery_date, :name, :amount, :id])
  end
end
