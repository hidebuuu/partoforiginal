class UsersController < ApplicationController
  before_action :set_user
  before_action :ensure_correct_user, only: %i[show edit update]

  def new
    @user = User.new
  end

  def edit
    @page_name = 'ユーザー情報編集'
  end

  def show
    @reviews_of_user = Review.review_of_user(@user.id).page(params[:page]).per(6)
    @page_name = "#{@user.name}さんのマイページ"
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'ユーザー情報を更新しました'
      redirect_to user_path(@user)
    else
      flash[:danger] = 'ユーザー情報を更新しました'
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :image, :screen_name)
  end

  def ensure_correct_user
    redirect_to root_path, flash[:danger] = '権限がありません' if @user.id != current_user.id
  end
end
