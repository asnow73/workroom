class StaticPagesController < ApplicationController
  def home
    @posts = Post.where(published: true).last(4)

    @links = Link.order('RANDOM()').first(6)

    @books = Book.where(published: true).order('RANDOM()').first(1)
    @number_symbols_summary_description = 128
  end

  def resume
  end
end
