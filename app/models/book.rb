class Book < ActiveRecord::Base
  belongs_to :category

  validates :name, :description, :category, presence: true
  validates :name, uniqueness: { scope: :category_id, case_sensitive: true }

  def self.categories
    section = Section.find_by_name("books")
    Category.where(section_id: section)
  end
end
