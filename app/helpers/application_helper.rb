require "net/http"

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

  def span_type(groups, common_number_spans)
    "span" << (common_number_spans / groups.count).to_s
  end

  def favicon_for(url)
    matches = url.match(/[^:\/]\/(.*)/)
    if matches
      image_tag url.sub(matches[1], '') + '/favicon.ico', {width: '16px', height: '16px'}
    else
      ""
    end
  end

end