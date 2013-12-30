class Web::BooksController < ApplicationController
  include Publishable

  def index
    if books_params.has_key?(:category_id)
      @books = Book.where(category_id: books_params[:category_id], published: true)
    else
      @books = Book.where(published: true)
    end

    @q = @books.ransack params[:q]
    @books = @q.result.order('created_at DESC').page(params[:page])
    
    @categories = Book.categories
    @number_symbols_summary_description = 128
  end

  def show
    @book = Book.find(params[:id])
    if published_content?(@book)
      @book
    else
      not_found
    end
  end

  private
    def books_params
      params.permit(:category_id)
    end  
end
