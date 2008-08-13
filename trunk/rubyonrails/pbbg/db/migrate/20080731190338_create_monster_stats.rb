class CreateMonsterStats < ActiveRecord::Migration
  def self.up
    create_table :monster_stats do |t|
      t.references :monster
      t.references :stat
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :monster_stats
  end
end
