class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :is_rfs_host?
  before_action :authenticate_user!


  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def is_rfs_host?
    ENV['HOSTNAME'] == 'RFS'
  end

  def is_ug_host?
    ENV['HOSTNAME'] == 'UG'
  end
end
