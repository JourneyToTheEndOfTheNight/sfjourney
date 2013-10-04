class AddCheckedInToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :checked_in, :boolean, :default => false
  end
end
