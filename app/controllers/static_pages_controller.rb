class StaticPagesController < ApplicationController
  def home
    @posts = Post.last(3)

    @links = Link.order('RANDOM()').first(6)

    @books = Book.order('RANDOM()').first(1)
    @number_symbols_summary_description = 128
  end
end
