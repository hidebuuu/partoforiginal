class LikesController < ApplicationController
  before_action :set_like, only: %i[destroy]

  def index
    @reviews_of_user_likes = current_user.likes.page(params[:page]).per(10)
  end

  def create
    @like = Like.new(user_id: current_user.id, review_id: params[:review_id])
    if @like.save
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @like.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def set_like
    @like = Like.find(params[:id])
  end
end
