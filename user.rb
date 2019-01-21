class User < ApplicationRecord
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  validates :name, presence: true
  has_many :reviews, dependent: :destroy
  has_many :authentications, :dependent => :destroy
  has_many :likes, dependent: :destroy

  accepts_nested_attributes_for :authentications

  def my_review?(review_user_id)
    id == review_user_id
  end

  def my_question?(question_questioner_id)
    id == question_questioner_id
  end

  def my_answer?(answer_responser_id)
    id == answer_responser_id
  end

  def my_like(review)
    likes.find_by(user_id: id, review_id: review.id)
  end
end
