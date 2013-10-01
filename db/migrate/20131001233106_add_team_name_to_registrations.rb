class AddTeamNameToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :team_name, :string
    add_index :registrations, :team_name
  end
end
