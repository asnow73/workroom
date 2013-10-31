class Web::Admin::SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or admin_root_path
    else
      flash.now[:error] = 'Неверный e-mail или пароль'
      render 'new'
    end    
  end

  def destroy
    sign_out
    redirect_to admin_root_path
  end
end