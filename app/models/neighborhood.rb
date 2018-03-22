class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
  	start_date = Date.parse(start_date)
  	end_date = Date.parse(end_date)
  	self.listings.select do |listing|
  		listing.reservations.each do |res|
  			if res.checkin < end_date && res.checkout > start_date
  				false
  				break
  			elsif res.checkout > end_date && res.checkin < end_date
  				false
  				break
  			else
  				true
  			end
  		end
  	end

  end

  def reservations
  	self.listings.map{|listing| listing.reservations}.flatten
  end

  def self.highest_ratio_res_to_listings
  	highest = 0.0
  	neighborhood = nil
  	self.all.each do |n|
  		res_count = n.reservations.count

  		n.listings.count == 0 ? ratio = 0 : ratio = res_count/n.listings.count
  		if ratio > highest
  			highest = ratio
  			neighborhood = n
  		end
  	end
  	neighborhood
  end

  def self.most_res
  	most = 0
  	neighborhood = nil
  	self.all.each do |n|
  		if n.reservations.count > most
  			most = n.reservations.count
  			neighborhood = n
  		end
  	end
  	neighborhood
  end

end
