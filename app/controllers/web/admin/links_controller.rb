class Web::Admin::LinksController < Web::Admin::AdminApplicationController
  def index
    @q = Link.ransack params[:q]
    @links = @q.result.order(sort_string).page(params[:page])
  end

  def new
    @link = Link.new
    # @categories_for_links = categories_for_links
    @categories_for_links = Link.categories
  end

  def create
    @link = Link.new(link_params)
    if @link.save
      flash[:success] = "Ссылка создана"
      redirect_to admin_links_url
    else
      render 'new'
    end
  end

  def destroy
    Link.find(params[:id]).destroy
    flash[:success] = "Ссылка удалена"
    redirect_to admin_links_url
  end

  def edit
    @link = Link.find(params[:id])
    # @categories_for_links = categories_for_links
    @categories_for_links = Link.categories
  end

  def update
    @link = Link.find(params[:id])
    if @link.update_attributes(link_params)
      flash[:success] = "Ссылка обновлена"
      redirect_to admin_links_url
    else
      render 'edit'
    end

  end

    private
    # Never trust parameters from the scary internet, only allow the white list through.
    def link_params
      params.require(:link).permit(:url, :description, :category_id, :published)
    end
end
