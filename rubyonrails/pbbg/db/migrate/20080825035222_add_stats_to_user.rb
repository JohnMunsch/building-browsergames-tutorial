class AddStatsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :attack, :int, :default => 10
    add_column :users, :defense, :int, :default => 9
    add_column :users, :magic, :int, :default => 8
  end

  def self.down
    remove_column :users, :magic
    remove_column :users, :defense
    remove_column :users, :attack
  end
end
