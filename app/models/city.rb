class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
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
  	city = nil
  	self.all.each do |c|
  		res_count = c.reservations.count
  		ratio = res_count/c.listings.count
  		if ratio > highest
  			highest = ratio
  			city = c
  		end
  	end
  	city
  end
  

  def self.most_res
  	most = 0
  	city = nil
  	self.all.each do |c|
  		if c.reservations.count > most
  			most = c.reservations.count
  			city = c
  		end
  	end
  	city
  end






end

