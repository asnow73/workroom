class PostDatatable
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Post.count,
      iTotalDisplayRecords: posts.count,
      aaData: data
    }
  end

private

  def data    
    posts.map do |post|
      [
        post.id,
        post.created_at,
        link_to(post.title, post),
        post.category.name,
        post.published,
        post.id,
        post.id
      ]
    end
  end

  def posts
    @posts ||= fetch_posts
  end

  def fetch_posts
    if params[:sSearch].present?
      posts = Post.search({search: params[:sSearch]})
    else
      posts = Post.all
    end
    posts = posts.order("#{sort_column} #{sort_direction}")
    posts = posts.page(page).per_page(per_page)
    #if params[:sSearch].present?
    #  posts = posts.where("title like :search", search: "%#{params[:sSearch]}%")
    #end
    posts
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[id created_at title category_id published] 
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end