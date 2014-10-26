class StaticPagesController < ApplicationController
  def home
    @posts = Post.where(published: true).last(4)

    @links = Link.order('RANDOM()').first(6)

  end

  def resume
  end
end
