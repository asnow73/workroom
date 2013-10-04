class Book < ActiveRecord::Base
  belongs_to :category

  validates :name, :description, :category, presence: true
  validates :name, uniqueness: { scope: :category_id, case_sensitive: true }
end
