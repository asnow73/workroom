class Post < ActiveRecord::Base
  belongs_to :category

  validates :title, :category_id, :content, presence: true
  validates :title, uniqueness: { scope: :category_id, case_sensitive: false }

  def self.categories
    section = Section.find_by_name("posts")
    Category.where(section_id: section)
  end

  def self.search(posts_params)
    posts = scoped
    posts = posts.where(published: true)
    posts = posts.where(category_id: posts_params[:category_id]) if posts_params.has_key?(:category_id)
    posts = posts.where("lower(title) LIKE lower(?)", "%" + posts_params[:search] + "%") if posts_params.has_key?(:search)
    posts
  end
end
