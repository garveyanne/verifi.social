require 'open-uri'

class CellsController < ApplicationController
  before_action :verify_authenticity_token, only: [:create]

  def index
    @cells = policy_scope(Cell)
  end

  def new
    @cell = Cell.new
    authorize @cell
  end

  def create
    @result = ImageResult.find(params[:image_result_id])
    image_into_grid(@result)
    verifi(@result)
    redirect_to image_results_path(@result)
  end

  def image_into_grid(result)
    # cloudinary_url = result.photo.url
    # image = ChunkyPNG::Image.from_blob(URI.open(cloudinary_url).read)
    # will break photo into 36 smaller photo grid (6x6)
    grid_size = 5
    # determines size of each grid square
    cell_width = result.width / grid_size
    cell_height = result.height / grid_size
    # itterate over the image grid cells
    # set the x and y axis points (top left corner of the cell)
    (0...grid_size).each do |row|
      (0...grid_size).each do |col|
        x = col * cell_width
        y = row * cell_height
        url = "https://res.cloudinary.com/#{ENV['CLOUDINARY_NAME']}/image/upload/c_crop,h_#{cell_height},w_#{cell_width},x_#{x},y_#{y}/v1/#{Rails.env}/#{result.photo.key}"
        authorize Cell.create(x_coor: x, y_coor: y, photo_url: url, image_result: result, row: row, col: col)
      end
    end
  end

  def verifi(result)
    result.cells.each do |cell|
      ######
      uri = URI('https://api.sightengine.com/1.0/check.json')
      params = {
        'url' => cell.photo_url,
        'models' => 'nudity-2.0,wad,offensive,text-content,gore',
        'api_user' => ENV['API_USER'],
        'api_secret' => ENV['API_SECRET']
      }
      #####
      uri.query = URI.encode_www_form(params)
      response = Net::HTTP.get_response(uri)
      output = JSON.parse(response.body)
      p "CELL"
      p cell
      p cell.sexual_activity
      p output
      p output["nudity"]
      p output["nudity"]["sexual_activity"]
      cell.sexual_activity = output["nudity"]["sexual_activity"]
      cell.sexual_display = output["nudity"]["sexual_display"]
      cell.erotica = output["nudity"]["erotica"]
      cell.drugs = output["drugs"]
      cell.gore = output["gore"]["prob"]
      if output["text"]["profanity"][0]
        cell.profanity_type = output["text"]["profanity"][0]["type"]
        cell.profanity_match = output["text"]["profanity"][0]["match"]
        cell.profanity_intensity = output["text"]["profanity"][0]["intensity"]
      end
      cell.save
    end
  end

  private

  def cell_params
    params.require(:cell).permit(:photo)
  end
end
