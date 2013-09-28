class Section < ActiveRecord::Base
  before_save { |section| section.name = name.downcase }
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
end
