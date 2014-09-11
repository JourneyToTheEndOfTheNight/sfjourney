class ExtendIpAddressLength < ActiveRecord::Migration
  def change
    change_column :registrations, :ip_address, :string, :limit => 15
  end
end
