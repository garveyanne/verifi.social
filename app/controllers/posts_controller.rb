class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]

  def index
    @posts = policy_scope(Post).order(updated_at: :desc)
    if params[:query].present?
      @posts = @posts.search_by_title_and_content(params[:query])
    end
    if params[:tag_list].present?
      @posts = @posts.tagged_with(params[:tag_list])
    end
    @tags = ActsAsTaggableOn::Tag.most_used(10)
    @tags_first = @tags.first(4)
    @tags_extra = @tags.last(6)
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
    @comment = Comment.new
    authorize @post
    @post.notifications.where(user: current_user).update_all(unread: false)
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
      redirect_to posts_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @post = Post.find(params[:id])
    authorize @post
  end

  def update
    @post = Post.find(params[:id])
    authorize @post
    if @post.update(post_params)
      redirect_to post_path(params[:id])
    else
      render :edit, status: :unprocessable_entity
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
