class ImageResultsController < ApplicationController

  def index
    @results = policy_scope(Image_results)
  end

  def show
  @result = ImageResult.find(params[:id])
  authorize @image_results
  end

  def new
    @result = ImageResult.new
    authorize @image_results
  end

  def create
    @result = ImageResult.new
    @result.user = current_user
    verifi(@result) if @result.photo.attached?
    authorize @image_results
    if @result.save
      redirect_to image_results_path(@result)
    else
      render :new, status: :uprocessable_entity
    end
  end

  def verifi(result)
    uri = URI('https://api.sightengine.com/1.0/check.json')
    params = {
      'url' => 'https://wallpapercave.com/wp/aYLVhao.jpg',
      'models' => 'nudity-2.0,wad,offensive,gore',
      'api_user' => '1608682898',
      'api_secret' => 'PmEbv8uuWJUwtGinJATZ'
    }
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri)

    output = JSON.parse(response.body)
  end

  # Cloudinary::Utils.cloudinary_url(result.photo.key)

  # nudity.sexual_activity,nudity.sexual_display,nudity.erotica


  #### not needed for friday demo

  def destroy
    @result = ImageResults.find(params[:id])
    @result.destroy
    redirect_to image_results_path
  end
end
