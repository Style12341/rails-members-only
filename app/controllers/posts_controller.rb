class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  before_action :require_permission, only: %i[edit update destroy]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      redirect_to posts_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    return unless @post.nil?

    flash.now[:alert] = 'Post not found'
    render :root
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to posts_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end

  def require_permission
    return unless current_user != Post.find(params[:id]).user

    flash[:alert] = 'You are not allowed to do that'
    redirect_to root_path
    # Or do something else here
  end
end
