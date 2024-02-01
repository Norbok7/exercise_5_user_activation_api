# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  before_action :set_user
  before_action :set_post, only: [:show]
  before_action :check_user_activation, only: [:new, :create, :index, :show]

  def show
    # Check if the post exists and belongs to an active user
    if @post && @user.active?
      # Display the post
    else
      redirect_to @user, alert: 'Cannot view post for an inactive user or non-existent post.'
    end
  end

  def new
    @post = @user.posts.new
  end

  def create
    @post = @user.posts.new(post_params)
    if @post.save
      redirect_to @user, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_post
    @post = @user.posts.find_by(id: params[:id])
  end

  def check_user_activation
    unless @user.active?
      redirect_to @user, alert: 'Cannot create or view posts for an inactive user.'
    end
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
