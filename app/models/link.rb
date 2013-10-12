class Link < ActiveRecord::Base
  belongs_to :category

  validates :category_id, :url, :description, presence: true
  validates :url, uniqueness: { scope: :category_id, case_sensitive: false }

  def self.categories
    section = Section.find_by_name("links")
    Category.where(section_id: section)
  end

  def self.category_links(category, number_links_in_group = nil)
    if number_links_in_group
      Link.where(category_id: category).limit(number_links_in_group)
    else
      Link.where(category_id: category)
    end
  end

  def self.groups_links(number_links_in_group = nil)
    @group_links = Hash.new
    Link.categories.each do |category|
      @group_links[category] = Link.category_links(category, number_links_in_group)
    end
    @group_links
  end

end
