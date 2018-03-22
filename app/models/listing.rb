class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true

  after_create :change_host_status
  after_destroy :check_host_listings

  def change_host_status
  	self.host.host = true
  	self.host.save
  end

  def check_host_listings
  	if self.host.listings.count == 0
  		self.host.host = false
  		self.host.save
  	end
  end

  def average_review_rating
    sum = 0.0
    self.reviews.each {|review| sum += review.rating}
    sum/self.reviews.count
  end

  def is_available(start_date, end_date)

    self.reservations.each do |res|
      if res.checkin < end_date && res.checkout > start_date
        return false
      elsif res.checkout > end_date && res.checkin < end_date
        return false
      else
        true
      end
    end

  end
  
end
