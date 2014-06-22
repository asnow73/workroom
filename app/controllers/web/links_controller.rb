class Web::LinksController < ApplicationController

  def index
    number_links_in_group = 10
    @group_links = Link.groups_links(number_links_in_group)
    @categories = Link.categories
  end

  def index_category_links
    @category = Category.find_by_id(links_params[:category_id])
    @q = @category.links.where(published: true).ransack params[:q]
    @links = @q.result.order('created_at DESC').page(params[:page])
    @categories = Link.categories
  end

  private
    def links_params
      params.permit(:category_id)
    end

end
