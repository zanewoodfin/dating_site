module ApplicationHelper
  BASE_TITLE = "The Network"

  def full_title(page_title = '')
    if page_title.empty?
      BASE_TITLE
    else
      "#{BASE_TITLE} | #{page_title}"
    end
  end

  # sets heading to :heading, :title, or "The Network" in that priority
  def heading(page_heading = '', page_title = '')
    default_heading = BASE_TITLE
    if page_heading.empty? && page_title.empty?
      default_heading
    elsif page_heading.empty?
      page_title
    else
      page_heading
    end
  end

  def flash_class(type)
    "alert alert-" + case type
      when :success then "success"
      when :notice then "info"
      when :alert then "warning"
      when :error then "danger"
      else "invalid-type"
    end
  end

  def host
    if Rails.env.production?
      "http://zanes-social-network.herokuapp.com/"
    else
      "http://localhost:3000/"
    end
  end

  def header_links
    {
      members: header_hash('Members', users_path, 'members'),
      blocked: header_hash('Blocked', blocked_users_path, 'blocked')
    }
  end

  def format_time(time)
    formatted_time = if(cookies["browser.timezone"])
      time.in_time_zone(cookies["browser.timezone"]).strftime("%b %d, %Y %I:%M %P")
    else
      time.strftime("%b %d, %Y %I:%M %P %Z")
    end
    formatted_time.gsub(/0(\d:\d\d)/) { $1 }
  end

private

  def header_hash(text, path, id)
    {
      text: text,
      path: path,
      id: "header_#{id}"
    }
  end

  def create_badge(num)
    if num > 0
      " <span class='badge'>#{num}</span>"
    else
      ""
    end
  end
end
