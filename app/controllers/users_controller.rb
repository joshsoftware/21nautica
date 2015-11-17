class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user, only: [:edit, :update]
  load_and_authorize_resource

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(users_params)
    if @user.save
      flash[:notice] = "User created sucessfully"
      redirect_to users_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update(users_params)
      flash[:notice] = "User record updated sucessfully"
      #sign_in @user, bypass: true
      redirect_to users_path
    else
      render 'edit'
    end
  end

  private

  def find_user
    @user = User.find(params[:id]) 
  end

  def users_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :is_active, :role)
  end

end
