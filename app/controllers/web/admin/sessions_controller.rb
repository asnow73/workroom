class Web::Admin::SessionsController < ApplicationController
  def new
    if User.count == 0
      first_admin = User.new(name: "admin", email: "admin@admin.ru", password: "admin", password_confirmation: "admin")
      first_admin.save(validate: false)
      # redirect_to new_admin_user_url
      flash[:notice] = 'Был создан пользователь с email = admin@admin.ru и паролем = "admin". Для безопасности рекомендуется изменить email/пароль пользователя "admin"'
    end

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