class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :not_own_listing
  validate :is_available
  validate :valid_dates


  def duration
  	checkout.day - checkin.day
  end

  def total_price
  	duration * self.listing.price
  end

  private

  def not_own_listing
  	if self.listing.host == self.guest
  		self.errors[:host] << 'cannot be both host and guest'
  	end
  end

  def is_available
  	if self.checkin && self.checkout && !self.listing.is_available(self.checkin, self.checkout)
  		self.errors[:dates] << 'are unavailable'
  	end
  end

  def valid_dates
  	if self.checkin && self.checkout
	  	if self.checkin >= self.checkout
	  		self.errors[:dates] << 'checkin must be before checkout'
	  	end
	end
  end



end
