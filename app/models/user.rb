class User < ActiveRecord::Base
  has_many :services
  has_many :registrations

  def registrations_for(game)
    registrations.where(:game_id => game.id)
  end

  # allow extra space for defined friends
  def friend_space?(game)
    (email.length > 5) && ENV['FRIENDS'].include?(email) && registrations_for(game).count < 1
  end
end

