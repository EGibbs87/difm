class CreditCard < ApplicationRecord
  belongs_to :user

  def set_last_digits
    if number
      number.to_s.gsub!(/\s/,'')
      self.digits ||= number.to_s.length <= 4 ? number : number.to_s.slice(-4..-1)
    end
    puts self.inspect
  end

  attr_accessor :number, :cvc

  before_validation :set_last_digits

  validates :digits, :presence => true
  validates :month, :presence => true, :numericality => { :greater_than_or_equal_to => 1, :less_than_or_equal_to => 12 }
  validates :year, :presence => true, :numericality => { :greater_than_or_equal_to => Datetime.now.year }

end
