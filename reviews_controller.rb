class ReviewsController < ApplicationController
  before_action :set_review, only: %i[show edit update destroy]
  skip_before_action :require_login, only: [:index, :show]
  before_action :ensure_correct_user, only: %i[edit update destroy]

  def index
    @q = Review.search(params[:q])
    @reviews = @q.result(distinct: true).order(updated_at: :desc).page(params[:page]).per(6)
  end

  def show
    @user = User.find_by(id: @review.user_id)
    @comments = Comment.where(review_id: @review).order(updated_at: :desc).page(params[:page]).per(6)
    @comment = Comment.new
    @like = current_user.my_like(@review) if session[:user_id].present?
  end

  def new
    @review = Review.new
  end

  def edit; end

  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    @review.uuid = SecureRandom.uuid

    if @review.save
      flash[:success] = 'クチコミを投稿しました'
      redirect_to review_path(@review)
    else
      flash[:danger] = 'クチコミの投稿に失敗しました'
      render :new
    end
  end

  def update
    if @review.update(review_params)
      flash[:success] = 'クチコミを更新しました'
      redirect_to review_path(@review)
    else
      flash[:danger] = 'クチコミの更新に失敗しました'
      render :edit
    end
  end

  def destroy
    @review.destroy
    flash[:success] = 'クチコミを削除しました'
    redirect_to user_path(params[:format])
  end

  private

  def set_review
    @review = Review.find_by!(id: params[:id])
  end

  def review_params
    params.require(:review).permit(:school_id, :user_id, :rating, :wait_question, :ng_question, :course)
  end

  def ensure_correct_user
    redirect_to root_path, flash[:danger] = '権限がありません' if !current_user.my_review?(@review.user_id)
  end
end
