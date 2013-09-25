class Category < ActiveRecord::Base
  before_save { |category| category.name = name.downcase }
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  has_many :links, dependent: :destroy
end
