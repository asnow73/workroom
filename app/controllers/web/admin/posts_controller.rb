class Web::Admin::PostsController < Web::Admin::AdminApplicationController
  def index
    #@q = Post.ransack params[:q]
    #@posts = @q.result.order(sort_string).page(params[:page])
    respond_to do |format|
      format.html do
        @categories = Category.all
      end
      format.json do
        render json: PostDatatable.new(view_context)
      end
    end
  end

  def new
    @post = Post.new
    @categories_for_posts = Post.categories
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:success] = "Заметка создана"
      redirect_to admin_posts_url
    else
      render 'new'
    end
  end

  def destroy
    Post.find(params[:id]).destroy
    flash[:success] = "Заметка удалена"
    redirect_to admin_posts_url
  end

  def edit
    @post = Post.find(params[:id])
    @categories_for_posts = Post.categories
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(post_params)
      flash[:success] = "Заметка обновлена"
      redirect_to admin_posts_url
    else
      render 'edit'
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :content, :preview, :category_id, :published, :tag_list)
    end

end
