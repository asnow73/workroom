class Post < ActiveRecord::Base
  belongs_to :category

  validates :title, :category_id, :content, presence: true
  validates :title, uniqueness: { scope: :category_id, case_sensitive: false }
end
