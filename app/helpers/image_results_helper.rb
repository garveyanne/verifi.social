module ImageResultsHelper
  def bar_chart_color(value)
    return "#927ac1" if value.to_i > 40
    return "#ffff99" if value.to_i > 20
    "#ff6384cc" # default color
  end
end
