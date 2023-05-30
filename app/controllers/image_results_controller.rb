require 'open-uri'
require 'fastimage'

class ImageResultsController < ApplicationController
  before_action :verify_authenticity_token, only: [:create]

  def index
    @results = policy_scope(ImageResult)
  end

  def show
    @descriptions = {
      "Sexual Activity" => "Sexual intercourse with clear nudity, including genital-genital and oral-genital activity
      Clear masturbation\n Direct touching of genitals
      Sex toys involved in sexual activity: penetrating mouth, anus or genitals. Includes dildos, sex dolls, fleshlights, plugs.
      Semen or vaginal fluids on faces or body parts",
      "Sexual Display" => "Exposure of genitals/sexual organs\n Exposed genitalia (transgender included), vulva, anus, male penises, both erect and non-erect, or testicles, either directly visible or through transparent, see-through or sheer clothing\n Sex toys not in use: dildos, sex dolls, fleshlights, butt plugs & beads",
      "Erotica" => "Exposure of breasts, nude buttocks or the pubic region\n Nude female breasts, female breasts with visible nipples or areola\n Nude buttocks, both male and female, in a non-sexual setting\n Pubic region, pubic hair, female crotch region or area around genitals with no genitals visible",
      "Drugs" => "Recreational drugs such as cannabis, syringes, pills and Self administration of some recreational drugs such as ketamine, cocaine.",
      "Gore" => "Horrific imagery such as blood, guts, self-harm,or wounds"
    }

    @result = ImageResult.find(params[:id])
    @cell = Cell.new
    @categories = {
      "Sexual Activity" => nil,
      "Sexual Display" => nil,
      "Erotica" => nil,
      "Drugs" => nil,
      "Gore" => nil
    }
    @categories["Sexual Activity"] = (@result.sexual_activity * 100) if @result.sexual_activity >= 0.05
    @categories["Sexual Display"] = (@result.sexual_display * 100) if @result.sexual_display >= 0.05
    @categories["Erotica"] = (@result.erotica * 100) if @result.erotica >= 0.05
    @categories["Drugs"] = (@result.drugs * 100) if @result.drugs >= 0.05
    @categories["Gore"] = (@result.gore * 100) if @result.gore >= 0.05

    colorarray = []
    @categories.each do |name, value|
      if value.to_i > 60
        colorarray << "#ff6384cc"
      elsif value.to_i > 30
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
      if value.to_i > 60
        @danger << name
      elsif value.to_i > 30
        @caution << name
      else
        @safe << name
      end
    end
    authorize @result
    @grid_size = 5
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
