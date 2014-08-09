class Game < ActiveRecord::Base
  has_many :registrations

  def max_registrations
    5000
  end

  def num_remaining
    max_registrations - registrations.count
  end
end

