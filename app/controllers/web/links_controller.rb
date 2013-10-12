class Web::LinksController < ApplicationController
  def index
    number_links_in_group = 10
    @group_links = Link.groups_links(number_links_in_group)
  end

end
