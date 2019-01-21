class CommentsController < ApplicationController
  before_action :twitter, only: [:create]
  before_action :set_review, only: %i[create edit destroy update]
  before_action :set_comment, only: %i[edit destroy update]

  def create
    @comment = Comment.new(comment_params.merge(user_id: current_user.id))
    if @comment.save
      if @comment.review.user.screen_name.present?
        @client.update('@' + "#{@comment.review.user.screen_name}" + ' '+ 'あなたの投稿にコメントが着きました!' + 'https://www.escola-pro.com/reviews/' + "#{@comment.review.id}")
      end
    flash[:success] = 'コメントを投稿しました'
    redirect_to review_path(@review)
    end
  end

  def destroy
    @comment.destroy
    flash[:success] = 'コメントを削除しました'
    redirect_to review_path(@review)
  end

  private

  def comment_params
    params.require(:comment).permit(:review_id, :user_id, :content)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_review
    @review = Review.find(params[:review_id])
  end

  def twitter
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_KEY']
      config.consumer_secret = ENV['TWITTER_SECRET']
      config.access_token = ENV['twitter_access_token']
      config.access_token_secret =  ENV['twitter_access_token_secret']
    end
  end
end
