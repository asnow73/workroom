class Web::Admin::CategoriesController < Web::Admin::AdminApplicationController
  def index
    # @categories = Category.paginate(page: params[:page])
    @q = Category.ransack params[:q]
    @categories = @q.result.order(sort_string).page(params[:page])
    # @categories = @q.result.page(params[:page])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "Категория создана"
      redirect_to admin_categories_url
    else
      render 'new'
    end
  end

  def destroy
    Category.find(params[:id]).destroy
    flash[:success] = "Категория удалена"
    redirect_to admin_categories_url
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(category_params)
      flash[:success] = "Категория обновлена"
      redirect_to admin_categories_url
    else
      render 'edit'
    end
  end

    private
    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :section_id)
    end
end
