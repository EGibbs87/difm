class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :services
  has_many :requests
  has_many :reviews_for, :class_name => "UserReview", :foreign_key => "for_user_id"
  has_many :reviews_by, :class_name => "UserReview", :foreign_key => "by_user_id"

  has_many :credit_cards, :dependent => :destroy

  after_commit :assign_customer_id, :on => :create

  validates :username, :presence => true, :uniqueness => { :case_sensitive => false }
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
  
  validate :validate_username

  
  attr_writer :login

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

  def assign_customer_id
    customer = Stripe::Customer.create(email: email)
    self.customer_id = customer.id
    self.save
  end

  def login
    @login || self.username || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      conditions[:email].downcase! if conditions[:email]
      where(conditions.to_h).first
    end
  end

  def reviews(role)
    return self.reviews_for.where(role: role)
  end
end
