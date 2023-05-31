require 'open-uri'
require 'fastimage'

class ImageResultsController < ApplicationController
  before_action :verify_authenticity_token, only: [:create]

  def index
    @results = policy_scope(ImageResult)
  end

  def show
    @image_result = ImageResult.new
    # descriptions for the seemore effect
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
    # find the result to be displayed
    @result = ImageResult.find(params[:id])
    #### BAR GRAPH #####
    # cat assignment for bar graph
    @categories = {
      "Sexual Activity" => nil,
      "Sexual Display" => nil,
      "Erotica" => nil,
      "Drugs" => nil,
      "Gore" => nil
    }
    # add the result stat if it is higher than 0.5. multiple by 100 to make it a nice % for the bar graph
    @categories["Sexual Activity"] = (@result.sexual_activity.to_f * 100) if @result.sexual_activity.to_f >= 0.05
    @categories["Sexual Display"] = (@result.sexual_display.to_f * 100) if @result.sexual_display.to_f >= 0.05
    @categories["Erotica"] = (@result.erotica.to_f * 100) if @result.erotica.to_f >= 0.05
    @categories["Drugs"] = (@result.drugs.to_f * 100) if @result.drugs.to_f >= 0.05
    @categories["Gore"] = (@result.gore.to_f * 100) if @result.gore.to_f >= 0.05

    # set the colors for the bar graph
    colorarray = []
    @categories.each do |_name, value|
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

    # create arrays to hold the names of which cat are danger, caution, or safe
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

    # defined for the create cell button to use
    @grid_size = 5
    @cell = Cell.new
    # reading the results from the grid APIs
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
    # if the image has the blur effect added, will add file manually to form
    if params[:url_image]
      @result = ImageResult.new
      file = URI.open(params[:url_image])
      @result.photo.attach(io: file, filename: "photo.png")
    else
      # otherwise will just create a form to be added
      @result = ImageResult.new(result_params)
    end
    @result.user = current_user
    authorize @result
    # saving the result
    if @result.save
      verifi(@result) if @result.photo.attached?
      redirect_to image_result_path(@result)
      # save the file size to be used to make a grid
      size = FastImage.size(@result.photo.url)
      @result.width = size[0]
      @result.height = size[1]
      @result.save
    else
      render :new, status: :uprocessable_entity
    end
  end

  def verifi(result)
    #call the API for info
    uri = URI('https://api.sightengine.com/1.0/check.json')
    params = {
      'url' => result.photo.url,
      'models' => 'nudity-2.0,wad,offensive,text-content,gore',
      'api_user' => ENV['API_USER'],
      'api_secret' => ENV['API_SECRET']
    }
    # recieve data and save
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri)
    output = JSON.parse(response.body)
    # failure message
    return if output["status"] == "failure"
    # assign values to result(or cell)
    if output["nudity"]
      result.sexual_activity = output["nudity"]["sexual_activity"]
      result.sexual_display = output["nudity"]["sexual_display"]
      result.erotica = output["nudity"]["erotica"]
    end
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
