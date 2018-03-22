class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
  	self.listings.map {|listing| listing.guests}.flatten if self.listings
  end

  def hosts
  	self.trips.map {|trip| trip.listing.host} if self.trips
  end

  def host_reviews
  	self.listings.map {|listing| listing.reviews}.flatten if self.listings
  end
  
end
