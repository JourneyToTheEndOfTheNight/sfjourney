class User < ActiveRecord::Base
  has_many :services
  has_many :registrations

  def friend_space?
    ENV['FRIENDS'].include?(email) && registrations.count < 2
  end


end

