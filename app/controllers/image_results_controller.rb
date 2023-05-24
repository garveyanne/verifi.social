class ImageResultsController < ApplicationController

  def index
    @results = policy_scope(Image_results)
  end

  def show
  @result = ImageResult.find(params[:id])
  authorize @image_result
  end

  def new
    @result = ImageResult.new
    authorize @result
  end

  def create
    @result = ImageResult.new(result_params)
    @result.user = current_user
    authorize @image_results
    if @result.save
      verifi(@result) if @result.photo.attached?
      redirect_to image_results_path(@result)
    else
      render :new, status: :uprocessable_entity
    end
  end

  def verifi(result)
    uri = URI('https://api.sightengine.com/1.0/check.json')
    params = {
      'url' => Cloudinary::Utils.cloudinary_url(result.photo.key),
      'models' => 'nudity-2.0,wad,offensive,gore',
      'api_user' => '1608682898',
      'api_secret' => 'PmEbv8uuWJUwtGinJATZ'
    }
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri)

    output = JSON.parse(response.body)
    result.sexual_activity = output["nudity"]["sexual_activity"]

  end

  #### not needed for friday demo

  def destroy
    @result = ImageResults.find(params[:id])
    @result.destroy
    redirect_to image_results_path
  end

  private

  def result_params
    params.require(:image_result).permit(:photo)
  end
end
