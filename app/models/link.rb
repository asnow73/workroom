class Link < ActiveRecord::Base
  belongs_to :category

  validates :category_id, :url, :description, presence: true
  validates :url, uniqueness: { scope: :category_id, case_sensitive: false }
end
