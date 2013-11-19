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
      home: header_hash("Home", root_path, 'home'),
      browse: header_hash("Browse", users_path, 'browse'),
      messages: header_hash("Messages#{create_badge current_user.unread_message_count}", messages_path, 'messages'),
      likes: header_hash("Likes#{create_badge current_user.new_likers_count}", likes_path, 'likes'),
      blocked: header_hash("Blocked#{create_badge current_user.new_blockers_count}", blocked_users_path, 'blocked'),
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

  def time_since(time)
    current_time = DateTime.now
    if time > current_time - 1.minute
      "now"
    elsif time > current_time - 1.hour
      pluralize(((current_time.to_i - time.to_i) / 60), 'minute') + " ago"
    elsif time > current_time - 1.day
      pluralize(((current_time.to_i - time.to_i) / 3600), 'hour') + " ago"
    else
      pluralize(((current_time.to_i - time.to_i) / 86400), 'day') + " ago"
    end
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
