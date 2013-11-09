class User < ActiveRecord::Base
  has_many :services
  has_many :registrations

  def friend_space?
    (email.length > 5) && ENV['FRIENDS'].include?(email) && registrations.count < 1
  end


end

