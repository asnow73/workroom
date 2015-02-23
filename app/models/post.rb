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

  def self.filter(params)
    posts = scoped
    posts = posts.where("lower(title) LIKE lower(?)", "%" + params[:sSearch_2] + "%") if params.has_key?(:sSearch_2) && !params[:sSearch_2].empty?
    posts = posts.order("#{sort_column(params[:iSortCol_0].to_i)} #{params[:sSortDir_0]}")
    
    if params.has_key?(:sSearch_3) && !params[:sSearch_3].empty?
      categoryIds = params[:sSearch_3].split(',')
      categoryIds.each do |categoryId|
        posts = posts.where("category_id = ?", categoryId)
      end
    end

    if params.has_key?(:sSearch_4) && !params[:sSearch_4].empty?
      publisheds = params[:sSearch_4].split(',')
      publisheds.each do |pub|
        posts = posts.where("published = ?", pub[0]) if !pub.empty?
      end
    end    

    pg = getPage(params)
    pp = getPerPage(params)
    posts = posts.page(pg).per_page(pp)
    posts
  end

  private
    def self.getPage(params)
      params[:iDisplayStart].to_i/per_page + 1
    end

    def self.getPerPage(params)
      params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
    end

    def self.sort_column(number_column)
      columns = %w[id created_at title category_id published] 
      columns[number_column]
    end

    #def self.sort_direction()
    #  params[:sSortDir_0] == "desc" ? "desc" : "asc"
    #end
end
