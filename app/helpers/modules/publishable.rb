module Publishable
  def published_content?(content)
    content.published || signed_in?
  end
end
