class CreateMonsters < ActiveRecord::Migration
  def self.up
    create_table :monsters do |t|
      t.string :name
      t.integer :attack
      t.integer :defense
      t.integer :magic
      t.integer :gold
      t.integer :max_hp
      t.integer :cur_hp

      t.timestamps
    end

    # Add the maximum hitpoints and current hitpoints stats to the user.
    # Note: Setting the defaults here will set default values for any existing
    # users already in the database as well as for any new ones created. So we
    # won't have to update the before_create method in the User model to set 
    # defaults for these values.
    add_column :users, :max_hp, :integer, :default => 10
    add_column :users, :cur_hp, :integer, :default => 10

    # Create some example monsters.
    Monster.create(:name => 'Crazy Eric', :attack => 2, :defense => 2, 
      :max_hp => 8, :gold => 5)
    Monster.create(:name => 'Lazy Russell', :attack => 1, :defense => 0, 
      :max_hp => 4, :gold => 20)
    Monster.create(:name => 'Hard Hitting Louis', :attack => 4, :defense => 3, 
      :max_hp => 10, :gold => 5)
  end

  def self.down
    remove_column :users, :cur_hp
    remove_column :users, :max_hp
  
    drop_table :monsters
  end
end
