module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "WorkRoom"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def summary_for_html_text(text)
    length = 255
    return '' if text.blank?
    truncate( sanitize(text, :tags => []), :length => length ).gsub(/\r/, "").gsub(/\n/, "").gsub(/&[a-z]{0-5}\.\.\.$/, "...")
  end
end
