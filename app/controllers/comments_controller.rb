class CommentsController < ApplicationController

  def new
    @post = Post.find(params[:post_id])
    @comment = Comment.new
    authorize @comment
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.post = @post
    authorize @comment
    if @comment.save
      Notification.create(post: @post, user: @post.user)
      redirect_to post_path(@post)
    else
      render :new, status: :unprocessable_entity
    end
  end

  ### below here is not needed for friday demo so low priority

  def edit
    @comment = Comment.find(params[:id])
    authorize @comment
  end

  def update
    @comment = Comment.find(params[:id])
    @post = comment.post
    authorize @comment
    if @comment.update(comment_params)
      redirect_to post_path(@post)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @post = @comment.post
    authorize @comment
    if @comment.destroy
      redirect_to post_path(@post)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
