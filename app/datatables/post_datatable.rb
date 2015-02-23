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
    posts = Post.filter(params)
    #posts = posts.page(page).per_page(per_page)
    posts
  end

end