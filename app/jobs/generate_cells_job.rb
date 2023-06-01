class GenerateCellsJob < ApplicationJob
  queue_as :default

  def perform(result)
    grid_size = 5
    # determines size of each grid square
    cell_width = result.width / grid_size
    cell_height = result.height / grid_size
    # itterate over the image grid cells
    # set the x and y axis points (top left corner of the cell)
    (0...grid_size).map do |row|
      (0...grid_size).map do |col|
        x = col * cell_width
        y = row * cell_height
        # build the URL to request a cropped portion of that image
        url = "https://res.cloudinary.com/#{ENV['CLOUDINARY_NAME']}/image/upload/c_crop,h_#{cell_height},w_#{cell_width},x_#{x},y_#{y}/v1/#{Rails.env}/#{result.photo.key}"
        # verifi(result) is done before creation on the model
        # create cells with all info needed
        cell = Cell.create(x_coor: x, y_coor: y, photo_url: url, image_result_id: result.id, row: row, col: col)
        VerifiCellsJob.perform_later(cell)
      end
    end
  end
end
