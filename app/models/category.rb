class Category < ActiveRecord::Base
  before_save { |category| category.name = name.downcase }
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
end
