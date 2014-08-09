class User < ActiveRecord::Base
  has_many :services
  has_many :registrations

  def registrations_for(game_id)
    registrations.where(:game_id => game_id)
  end

  # allow extra space for defined friends
  def friend_space?(game_id)
    (email.length > 5) && ENV['FRIENDS'].include?(email) && registrations_for(game_id).count < 1
  end
end

