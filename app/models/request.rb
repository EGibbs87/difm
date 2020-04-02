class Request < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :classifications

  validates_format_of :location, :with => /\d{5}/, :message => "Please use a 5-digit zip code for primary zip code"
  validates_presence_of [:location, :range, :description, :timeframe, :expiration], :message => "Please be sure to fill out all fields"

  after_validation :geocode

  geocoded_by :zip

  def zip
    return [self.location, "USA"].join(", ")
  end
end
