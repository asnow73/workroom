class Post < ActiveRecord::Base
  belongs_to :category

  validates :title, :category_id, :content, presence: true
  validates :title, uniqueness: { scope: :category_id, case_sensitive: false }

  def self.categories
    section = Section.find_by_name("posts")
    Category.where(section_id: section)
  end
end
