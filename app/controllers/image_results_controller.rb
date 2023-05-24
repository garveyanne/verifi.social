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
    ### here is where we will call the method to run the API
    @result.user = current_user
    authorize @image_results
    if @result.save
      redirect_to image_results_path(@result)
    else
      render :new, status: :uprocessable_entity
    end
  end


  def verifi()
    uri = URI('https://api.sightengine.com/1.0/check.json')

    params = {
      'url' => '',
      'models' => 'nudity.sexual_activity,nudity.sexual_display,nudity.erotica,wad,offensive',
      'api_user' => '{api_user}',
      'api_secret' => '{api_secret}'
    }

    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri)

    output = JSON.parse(response.body)

  end
  #### not needed for friday demo

  def destroy
    @result = ImageResults.find(params[:id])
    @result.destroy
    redirect_to image_results_path
  end
end
