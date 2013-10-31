class Web::Admin::BooksController < Web::Admin::AdminApplicationController
  def index
    @q = Book.ransack params[:q]
    @books = @q.result.order('created_at DESC').page(params[:page])
  end

  def new
    @book = Book.new
    # @categories_for_books = categories_for_books
    @categories_for_books = Book.categories
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      flash[:success] = "Книга создана"
      redirect_to admin_books_url
    else
      render 'new'
    end
  end

  def destroy
    Book.find(params[:id]).destroy
    flash[:success] = "Книга удалена"
    redirect_to admin_books_url
  end

  def edit
    @book = Book.find(params[:id])
    # @categories_for_books = categories_for_books
    @categories_for_books = Book.categories
  end

  def update
    @book = Book.find(params[:id])
    if @book.update_attributes(book_params)
      flash[:success] = "Книга обновлена"
      redirect_to admin_books_url
    else
      render 'edit'
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:name, :description, :category_id, :image_url, :source_url)
    end
end
