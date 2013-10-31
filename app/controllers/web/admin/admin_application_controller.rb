class Web::Admin::AdminApplicationController < ApplicationController
  # before_action :require_login
  before_action :signed_in_user

 
  # private
  #   def require_login
  #     if !signed_in?
  #       # flash[:error] = "Вы должны подтвердить права администратора"
  #       redirect_to admin_signin_path
  #     end
  #   end
end
