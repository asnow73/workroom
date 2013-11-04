class Web::Admin::UsersController < Web::Admin::AdminApplicationController
  def index
    @q = User.ransack params[:q]
    @users = @q.result.order('created_at DESC').page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Пользователь создан"
      redirect_to admin_users_url
    else
      render 'new'
    end
  end

  def destroy
    user = User.find(params[:id])
    if (user == current_user)
      flash[:error] = "Вы не можете удалить собственный акаунт"
    else
      user.destroy
      flash[:success] = "Пользователь удален"
    end
    redirect_to admin_users_url
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Информация о пользователе обновлена"
      redirect_to admin_users_url
    else
      render 'edit'
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end


end
