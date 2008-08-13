class CreateStats < ActiveRecord::Migration
  def self.up
    create_table :stats do |t|
      t.string :display_name
      t.string :short_name

      t.timestamps
    end
  end

  def self.down
    drop_table :stats
  end
end
