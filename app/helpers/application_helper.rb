# Site-wide helper methods
module ApplicationHelper
  BASE_TITLE = 'Dating Site'

  def full_title(page_title = '')
    if page_title.empty?
      BASE_TITLE
    else
      "#{BASE_TITLE} | #{page_title}"
    end
  end

  # sets heading to :heading, :title, or "BASE_TITLE" in that priority
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
    'alert alert-' +
      case type
      when :success then 'success'
      when :notice then 'info'
      when :alert then 'warning'
      when :error then 'danger'
      else 'invalid-type'
      end
  end

  def host
    if Rails.env.production?
      ''
    else
      'http://localhost:3000/'
    end
  end

  def header_links
    message_badge = create_badge(current_user.unread_message_count)
    likes_badge = create_badge(current_user.new_likers_count)
    blockers_badge = create_badge(current_user.new_blockers_count)
    { home: header_hash('Home', root_path),
      browse: header_hash('Browse', users_path),
      messages: header_hash("Messages#{ message_badge }", messages_path),
      likes: header_hash("Likes#{ likes_badge }", likes_path),
      blocked: header_hash("Blocked#{ blockers_badge }", blocked_users_path),
      my_profile: header_hash('My Profile', current_user),
      logout: header_hash('Logout', destroy_user_session_path, :delete) }
  end

  def format_time(time)
    time_zone = cookies['browser.timezone']
    if time_zone
      time.in_time_zone(time_zone).strftime('%b %d, %Y %I:%M %P')
    else
      time.strftime('%b %d, %Y %I:%M %P %Z')
    end.gsub(/0(?<new_time>\d:\d\d)/) { '\k<new_time>' }
  end

  def time_since(time)
    current_time = DateTime.now
    if time > current_time - 1.minute
      'now'
    elsif time > current_time - 1.hour
      "#{ pluralize(((current_time.to_i - time.to_i) / 60), 'minute') } ago"
    elsif time > current_time - 1.day
      "#{ pluralize(((current_time.to_i - time.to_i) / 3_600), 'hour') } ago"
    else
      "#{ pluralize(((current_time.to_i - time.to_i) / 86_400), 'day') } ago"
    end
  end

  def build_select(attribute)
    set = User.const_get(attribute.upcase)
    [
      attribute,
      {
        collection: (0...set.length).map { |index| [set[index], index] },
        include_blank: false
      }
    ]
  end

  def populate_row(instance, attribute)
    "<td>#{attribute.to_s.gsub(/_/, ' ')}</td>"\
      "<td>#{instance.to_s attribute}</td>"
  end

  private

  def header_hash(text, path, method = false)
    id = text.downcase.gsub(/ <span.*span>/, '').gsub(/\s+/, '_')
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
      ''
    end
  end
end
