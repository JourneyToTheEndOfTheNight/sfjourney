tz = TZInfo::Timezone.get('America/Los_Angeles')
starts_at = tz.local_to_utc(DateTime.new(2015, 10, 31, 18, 0, 0))
Game.create!(:name => "San Francisco 2015", :starts_at => starts_at, :start_location => 'To Be Announced')
