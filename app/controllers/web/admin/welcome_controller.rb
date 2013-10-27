class Web::Admin::WelcomeController < ApplicationController
  def index
    if !signed_in?
      redirect_to admin_signin_path
    end
  end
end
