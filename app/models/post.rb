class Post < ActiveRecord::Base
  belongs_to :category

  validates :title, :category_id, :content, presence: true
  validates :title, uniqueness: { scope: :category_id, case_sensitive: false }

  #scope :published_filter, ->(pub) { where(published: pub) }
  #scope :title_like_filter, ->(title) { where("title like ?", "%#{title}%") }
  #scope :category_filter, ->(category_id) { where(category_id: category_id) }

  def self.categories
    section = Section.find_by_name("posts")
    Category.where(section_id: section)
  end

  def self.search(posts_params)
    posts = Post.all
    posts = posts.where(published: true)
    posts = posts.where(category_id: posts_params[:category_id]) if posts_params.has_key?(:category_id)
    posts = posts.where("lower(title) LIKE lower(?)", "%" + posts_params[:search] + "%") if posts_params.has_key?(:search)
    posts
  end

  def self.filter(params)
    posts = Post.all
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
    #posts = posts.page(2).per_page(10)
    #posts = posts.paginate(:page => params[:page], :per_page => 30)

    puts "AAAA LLLLL RRRRR " << pg.to_s << " " << pp.to_s << " | " << params[:iDisplayStart].to_s << " " << params[:iDisplayLength].to_s

    #posts = posts.offset(params[:iDisplayStart]).limit(params[:iDisplayLength])
    posts
  end

  #def self.filter2(params)
  #  posts = where(nil) #creates an anonymous scope
  #end

  
    def self.getPage(params)
      params[:iDisplayStart].to_i/getPerPage(params) + 1
    end

    def self.getPerPage(params)
      params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
    end
  
  private
    def self.sort_column(number_column)
      columns = %w[id created_at title category_id published] 
      columns[number_column]
    end

    #def self.sort_direction()
    #  params[:sSortDir_0] == "desc" ? "desc" : "asc"
    #end
end
