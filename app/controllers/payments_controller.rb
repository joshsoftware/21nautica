class PaymentsController < ApplicationController
  before_action :set_type

  def new
    @payment = @type.constantize.new
  end

  def create
    payment = Paid.new(payment_params(:paid)) if params.include?(:paid)
    payment = Received.new(payment_params(:received)) if params.include?(:received)
    if payment.save
      redirect_to :root
    else
      render text: payment.errors.full_messages
    end
  end

  private

  def set_type
    params_type = params[:type]
    @type = Payment.types.include?(params_type) ? params_type : "Payment"
  end

  def payment_params(payment_type)
    params.require(payment_type).permit(:participants_name, :date_of_payment,
            :amount, :mode_of_payment, :reference, :remarks)
  end

end
