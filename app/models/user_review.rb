class UserReview < ApplicationRecord
  belongs_to :for_user, :class_name => "User"
  belongs_to :by_user, :class_name => "User"

  validates_presence_of :stars
  validates_presence_of :content
  validates_presence_of :role

  scope :reviews_for, ->(user) { where("for_user_id = ?", user.id) }
  scope :reviews_by, ->(user) { where("by_user_id = ?", user.id) }
  scope :service_reviews_for, ->(user) { where("for_user_id = ? AND role = ?", user.id, "service") }
  scope :service_reviews_by, ->(user) { where("by_user_id = ? AND role = ?", user.id, "service") }
  scope :request_reviews_for, ->(user) { where("for_user_id = ? AND role = ?", user.id, "request") }
  scope :request_reviews_by, ->(user) { where("by_user_id = ? AND role = ?", user.id, "request") }

  def cannot_review_self
    if for_user_id == by_user_id
      errors.add(:for_user_id, "Can't review self")
    end
  end
end