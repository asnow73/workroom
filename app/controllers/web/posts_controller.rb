class Web::PostsController < ApplicationController
  include Publishable

  def index
    if (params[:tag])
      @posts = Post.tagged_with(params[:tag])
    else
      @posts = Post.search(posts_params)
    end
    @q = @posts.ransack params[:q]
    @posts = @q.result.order('created_at DESC').page(params[:page])
    @categories = Post.categories    
  end

  def show
    @categories = Post.categories
    @post = Post.find(params[:id])
    if published_content?(@post)
      @post
    else
      not_found
    end
  end

  private
    def posts_params
      params.permit(:category_id, :search, :tag)
    end
end
