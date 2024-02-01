# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  before_action :set_user
  before_action :check_user_activation, only: [:new, :create, :index]

  def index
    @posts = @user.posts if @user.active?
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

  def check_user_activation
    unless @user.active?
      redirect_to @user, alert: 'Cannot create or view posts for an inactive user.'
    end
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
