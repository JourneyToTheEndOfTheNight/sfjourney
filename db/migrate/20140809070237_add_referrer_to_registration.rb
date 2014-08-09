class AddReferrerToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :referrer, :text
    add_column :users, :referrer, :text
  end
end
