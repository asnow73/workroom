class Category < ActiveRecord::Base
  belongs_to :section
  has_many :links, dependent: :destroy
  has_many :books, dependent: :destroy
  has_many :posts, dependent: :destroy

  before_save { |category| category.name = name.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  validates :section_id, presence: true
  validates :name, uniqueness: { scope: :section_id, case_sensitive: false }
end
