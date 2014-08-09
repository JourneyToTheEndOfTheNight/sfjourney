class Game < ActiveRecord::Base
  has_many :registrations

  def max_registrations
    5000
  end

  def num_remaining
    max_registrations - registrations.count
  end

  def display_num_remaining
    num_remaining
  end

  def local_starts_at
    tz = TZInfo::Timezone.get(timezone)
    tz.utc_to_local(starts_at)
  end
end

