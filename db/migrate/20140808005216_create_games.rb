class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.date :starts_at
      t.timestamps
    end
    Game.create!(:name => "San Francisco 2013", :starts_at => Date.new(2013, 11, 9))
    add_column :registrations, :game_id, :integer
    execute("update registrations set game_id=1")
    Game.create!(:name => "San Francisco 2014", :starts_at => Date.new(2014, 10, 25))
    remove_index :registrations, :email
    add_index :registrations, [:game_id, :email]
    remove_index :registrations, :team_name
    add_index :registrations, :user_id
  end
end
