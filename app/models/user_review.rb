class UserReview < ApplicationRecord
  belongs_to :for_user, :class_name => "User"
  belongs_to :by_user, :class_name => "User"

  scope :reviews_for, ->(user) { where("for_user_id = ?", user.id) }
  scope :reviews_by, ->(user) { where("by_user_id = ?", user.id) }
  scope :service_reviews_for, ->(user) { where("for_user_id = ? AND role = ?", user.id, "service") }
  scope :service_reviews_by, ->(user) { where("by_user_id = ? AND role = ?", user.id, "service") }
  scope :request_reviews_for, ->(user) { where("for_user_id = ? AND role = ?", user.id, "request") }
  scope :request_reviews_by, ->(user) { where("by_user_id = ? AND role = ?", user.id, "request") }
end