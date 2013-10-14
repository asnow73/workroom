class Web::PostsController < ApplicationController
  def index
    if posts_params.has_key?(:category_id)
      posts = Post.where(category_id: posts_params[:category_id])
      @q = posts.ransack params[:q]
    else
      @q = Post.ransack params[:q]
    end
    @posts = @q.result.order('created_at DESC').page(params[:page])
    @categories = Post.categories
  end

  def show
    @post = Post.find(params[:id])
  end

  private
    def posts_params
      params.permit(:category_id)
    end
end
