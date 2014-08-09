class AddFieldsToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :user_agent, :text
    add_column :registrations, :ip_address, :string, :limit => 12
  end
end
