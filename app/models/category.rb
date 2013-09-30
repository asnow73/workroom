class Category < ActiveRecord::Base
  belongs_to :section
  has_many :links, dependent: :destroy

  before_save { |category| category.name = name.downcase }
  validates :name, :section_id, presence: true, length: { maximum: 50 }
  validates :name, uniqueness: { scope: :section_id, case_sensitive: false }
end
