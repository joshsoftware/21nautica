class FreezplsController < ApplicationController

  def new
    @freezpl = Freezpl.new
  end

  def create
    @date = params[:freezpl][:date].split('-')
    @date = Date.civil(@date[1].to_i, @date[0].to_i, -1)    
    @freezpl = Freezpl.new(date: @date)
    if @freezpl.save
      flash[:notice] =" saved"
      redirect_to :new_freezpl
    else
      flash[:error] = "error"
      render 'new'
    end
  end

end
