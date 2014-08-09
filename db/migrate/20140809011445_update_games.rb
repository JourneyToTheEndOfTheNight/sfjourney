class UpdateGames < ActiveRecord::Migration
  def change
    change_column :games, :starts_at, :datetime
    tz = TZInfo::Timezone.get('America/Los_Angeles')
    Game.find_by_name("San Francisco 2014").update_attributes!(:starts_at => tz.local_to_utc(DateTime.new(2014, 10, 25, 18, 0, 0)))
    add_column :games, :timezone, :string, :default => 'America/Los_Angeles'
  end
end
