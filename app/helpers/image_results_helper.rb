module ImageResultsHelper
  def bar_chart_color(categories)
    categories.each do |name, vale|
      return "#ff6384cc" if value.to_i > 40
      return "#ffff99" if value.to_i > 20
      return "#927ac1"
    end
  end
end
