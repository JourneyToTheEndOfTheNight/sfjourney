class AddTokenToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :token, :string, :limit => 6
    add_index :registrations, [:game_id, :token], :unique => true
  end
end
