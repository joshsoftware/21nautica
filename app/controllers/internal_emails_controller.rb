class InternalEmailsController < ApplicationController
  before_action :set_internal_email, only: %i[edit update]

  def index
    @internal_emails = InternalEmail.all
  end

  def new
    @internal_email = InternalEmail.new
  end

  def update
    if @internal_email.update(emails_params)
      flash[:notice] = "Internal emails updated successfully"
      redirect_to :internal_emails
    else
      flash[:error] = "Error"
      render 'edit'
    end
  end

  def create
    @internal_email = InternalEmail.new(emails_params)
    if @internal_email.save
      flash[:notice] = "Internal Email saved successfully"
      redirect_to :internal_emails
    else
      flash[:notice] = "Error"
      render 'new'
    end
  end

  private

  def emails_params
    params.require(:internal_email).permit(:id,:email_type,:emails)
  end

  def set_internal_email
    @internal_email = InternalEmail.find_by(id:params[:id])
  end
end
