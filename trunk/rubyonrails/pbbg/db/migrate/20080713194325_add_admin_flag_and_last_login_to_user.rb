class AddAdminFlagAndLastLoginToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :admin, :boolean, :default => false
    add_column :users, :last_login, :timestamp
  end

  def self.down
    remove_column :users, :last_login
    remove_column :users, :admin
  end
end
