class ImageResultsController < ApplicationController

  def index
    @results = policy_scope(Image_results)
  end

  def show
  @result = Image_result.find(params[:id])
  authorize @image_results
  end

  def new
    @result = Image_results.new
    authorize @image_results
  end

  def create
    @result = Image_results.new
    ### here is where we will call the method to run the API
    @result.user = current_user
    authorize @image_results
    if @result.save
      redirect_to image_results_path(@result)
    else
      render :new, status: :uprocessable_entity
    end
  end

  #### not needed for friday demo

  def destroy
    @result = Image_results.find(params[:id])
    @result.destroy
    redirect_to image_results_path
  end
end
