class Review < ApplicationRecord
  validates :school_id, presence: true
  validates :user_id, presence: true
  validates :rating, presence: true

  belongs_to :user
  belongs_to :school, class_name: 'Admin::School'
  has_many :comments ,dependent: :destroy
  has_many :likes, dependent: :destroy

  scope :review_of_user, ->(user_id) { where(user_id: user_id) }

  def my_like(user, review)
    likes.find_by(user_id: user.id, review_id: review.id)
  end

  enum attendance_period: {
    during_class: 0,
    recent_graduation: 1,
    old_graduation: 2
  }
end
