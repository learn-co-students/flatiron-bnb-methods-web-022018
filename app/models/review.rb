class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true
  validate :checked_out

  private

  def checked_out
  	if self.reservation
  		if self.reservation.status != 'accepted'
  			self.errors[:reservation] = 'not accepted'
  		elsif self.reservation.checkout >= Date.today
  			self.errors[:reservation] = 'not checked out yet'
  		end
  	else
  		self.errors[:reservation] = 'no reservation found'
  	end
  end

end
