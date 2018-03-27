module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    if title == "Created At"
      link_to "date", params.permit(:param_1, :param_2).merge(:sort => column, :direction => direction), {:class => css_class}
    else
      link_to title, params.permit(:param_1, :param_2).merge(:sort => column, :direction => direction), {:class => css_class}
    end
  end
end
