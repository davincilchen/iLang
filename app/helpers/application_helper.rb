module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    # https://stackoverflow.com/questions/46029084/rails-unable-to-convert-unpermitted-parameters-to-hash/46029217#46029217
    if title == "Created At"
      link_to "日期時間", params.to_unsafe_h.merge(:sort => column, :direction => direction), {:class => css_class}
    else
      link_to "課程主旨", params.to_unsafe_h.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
    end
  end
end
