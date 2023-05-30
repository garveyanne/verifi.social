require 'open-uri'
require 'fastimage'

class ImageResultsController < ApplicationController
  before_action :verify_authenticity_token, only: [:create]

  def index
    @results = policy_scope(ImageResult)
  end

  def show
    @result = ImageResult.find(params[:id])
    @cell = Cell.new
    @categories = {
      "Sexual Activity" => nil,
      "Sexual Display" => nil,
      "Erotica" => nil,
      "Suggestive" => nil,
      "Drugs" => nil,
      "Gore" => nil
    }
    @categories["Sexual Activity"] = (@result.sexual_activity * 100) if @result.sexual_activity >= 0.05
    @categories["Sexual Display"] = (@result.sexual_display * 100) if @result.sexual_display >= 0.05
    @categories["Erotica"] = (@result.erotica * 100) if @result.erotica >= 0.05
    @categories["Suggestive"] = (@result.suggestive * 100) if @result.suggestive >= 0.05
    @categories["Drugs"] = (@result.drugs * 100) if @result.drugs >= 0.05
    @categories["Gore"] = (@result.gore * 100) if @result.gore >= 0.05

    colorarray = []
    @categories.each do |name, value|
      if value.to_i > 40
        colorarray << "#ff6384cc"
      elsif value.to_i > 20
        colorarray << "#ffcc66cc"
      else
        colorarray << "#00cc99cc"
      end

    end

    Chartkick.options = {
      # [0] is safe, [1] is warning, [2] is danger
      colors: colorarray,
      max: 100
    }
    @danger = []
    @caution = []
    @safe = []
    @categories.each do |name, value|
      if value.to_i > 40
        @danger << name
      elsif value.to_i > 20
        @caution << name
      else
        @safe << name
      end
    end
    authorize @result
    @grid_size = 5

    if params[:x] && params[:y]
      respond_to do |format|
        format.html # Follow regular flow of Rails
        format.text { render partial: "image", locals: {x: params[:x], y: params[:y], src: @result.photo.key}, formats: [:html] }
      end
    end
  end

  def new
    @result = ImageResult.new
    authorize @result
  end

  def create
    @result = ImageResult.new(result_params)
    @result.user = current_user
    authorize @result
    if @result.save
      verifi(@result) if @result.photo.attached?
      redirect_to image_result_path(@result)
      size = FastImage.size(@result.photo.url)
      @result.width = size[0]
      @result.height = size[1]
      @result.save
    else
      render :new, status: :uprocessable_entity
    end
  end

  def verifi(result)
    uri = URI('https://api.sightengine.com/1.0/check.json')
    params = {
      'url' => result.photo.url,
      'models' => 'nudity-2.0,wad,offensive,text-content,gore',
      'api_user' => ENV['API_USER'],
      'api_secret' => ENV['API_SECRET']
    }
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri)
    output = JSON.parse(response.body)
    result.sexual_activity = output["nudity"]["sexual_activity"]
    result.sexual_display = output["nudity"]["sexual_display"]
    result.erotica = output["nudity"]["erotica"]
    result.suggestive = output["nudity"]["suggestive"]
    result.drugs = output["drugs"]
    result.gore = output["gore"]["prob"]
    if output["text"]["profanity"][0]
      result.profanity_type = output["text"]["profanity"][0]["type"]
      result.profanity_match = output["text"]["profanity"][0]["match"]
      result.profanity_intensity = output["text"]["profanity"][0]["intensity"]
    end
    result.save
  end

  def destroy
    @result = ImageResult.find(params[:id])
    @result.destroy
    authorize @result
    redirect_to image_results_path
  end

  private

  def result_params
    params.require(:image_result).permit(:photo)
  end
end
