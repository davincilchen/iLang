module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    if title == "Title"
      link_to title, {:sort => column, :direction => direction}, {:class => css_class}
    else
      link_to "date", {:sort => column, :direction => direction}, {:class => css_class}
    end
  end
end
