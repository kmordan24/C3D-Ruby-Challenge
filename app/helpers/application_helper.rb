# frozen_string_literal: true

module ApplicationHelper
  def dynamic_title
    case controller_name
    when 'events'
      'Events Manager'
    when 'places'
      'Places Manager'
    else
      'Welcome to Events Manager'
    end
  end

  def navigation_title
    case controller_name
    when 'places'
      link_to dynamic_title, places_path
    when 'events'
      link_to dynamic_title, events_path
    else
      dynamic_title
    end
  end
end
