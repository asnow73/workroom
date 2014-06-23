class Web::Admin::AdminApplicationController < ApplicationController
  # before_action :require_login

  before_action :signed_in_user

  private
    def sorting_on?
      (params[:q]) && (params[:q].include?(:s)) ? true: false
    end

    def sort_string
      # raise "XXXXXX" << sorting_on?.inspect
      sorting_on? ? '': 'created_at DESC'
    end
  # private
  #   def require_login
  #     if !signed_in?
  #       # flash[:error] = "Вы должны подтвердить права администратора"
  #       redirect_to admin_signin_path
  #     end
  #   end
end
