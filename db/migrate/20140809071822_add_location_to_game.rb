class AddLocationToGame < ActiveRecord::Migration
  def change
    add_column :games, :start_location, :string
    Game.find_by_name("San Francisco 2014").update_attributes!(:start_location => 'UN Plaza')
  end
end
