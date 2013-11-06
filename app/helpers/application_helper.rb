module ApplicationHelper
  BASE_TITLE = "Dating Site"

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
      ""
    else
      "http://localhost:3000/"
    end
  end

  def header_links
    {
      messages: header_hash("Messages#{create_badge current_user.unread_message_count}", messages_path, 'messages'),
      members: header_hash('Members', users_path, 'members'),
      blocked: header_hash('Blocked', blocked_users_path, 'blocked'),
      my_profile: header_hash('My Profile', current_user, 'my_profile'),
      logout: header_hash('Logout', destroy_user_session_path, 'logout', :delete)
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

  def build_select(type, clazz)
    set = clazz.const_get(type.upcase)
    [type,
      {
        collection: (0...set.length).map { |index| [set[index], index] },
        include_blank: false
      }
    ]
  end

  def populate_row(instance, attribute)
    "<td>#{attribute.to_s.gsub(/_/, ' ')}</td><td>#{instance.to_s attribute}</td>"
  end

private

  def header_hash(text, path, id, method = false)
    {
      text: text,
      path: path,
      id: "header_#{id}"
    }.tap { |hash| hash[:method] = method if method }
  end

  def create_badge(num)
    if num > 0
      " <span class='badge'>#{num}</span>"
    else
      ""
    end
  end
end
