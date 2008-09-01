class AddGoldToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :gold, :integer, :default => 0
    
    # Any existing users will get the new stat just like new users. If we had 
    # to do any special setup for the value though, we could do it here.
  end

  def self.down
    remove_column :users, :gold
  end
end
