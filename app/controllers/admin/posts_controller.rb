class Admin::PostsController < ApplicationController
  def index
    @q = Post.ransack params[:q]
    @posts = @q.result.order('created_at DESC').page(params[:page])
  end

  def new
    @post = Post.new
    @categories_for_posts = categories_for_posts
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
    @categories_for_posts = categories_for_posts
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
      params.require(:post).permit(:title, :content, :category_id)
    end

    def categories_for_posts
      section = Section.find_by_name("posts")
      Category.where(section_id: section)
    end

end
