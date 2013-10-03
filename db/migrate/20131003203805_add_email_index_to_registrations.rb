class AddEmailIndexToRegistrations < ActiveRecord::Migration
  def change
    add_index :registrations, :email
  end
end
