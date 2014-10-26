class Section < ActiveRecord::Base
  has_many :categories, dependent: :destroy

  before_save { |section| section.name = name.downcase }
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }

  def Section.create_default_sections
    unless Section.find_by_name("links")
      Section.create(name: "links")
    end

    unless Section.find_by_name("posts")
      Section.create(name: "posts")
    end
  end
end
