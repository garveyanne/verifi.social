class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]

  def index
    @posts = policy_scope(Post)
  end

  def show
    @post = Post.find(params[:id])
    @comments = Post.comments
    authorize @post
  end

  def new
    @post = Post.new
    authorize @post
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    authorize @post
    if @post.save
      redirect_to post_path(:id)
    else
      render :new, status: :uprocessable_entity
    end
  end

  ### below is not needed for Friday demo, so should be low priority for now

  def edit
    @post = Post.find(params[:id])
    authorize @post
  end

  def update
    @post = Post.find(params[:id])
    authorize @post
    if @post.update(post_params)
      redirect_to post_path(:id)
    else
      render :edit, status: :uprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])
    authorize @post
    if @post.destroy
      redirect_to posts_path
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :tag_list, :photo)
  end
end
