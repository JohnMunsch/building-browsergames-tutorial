class Monster < ActiveRecord::Base
  def self.random_encounter
    # For a single random record I'm using the technique from here:
    # http://robzon.aenima.pl/2007/12/selecting-random-row-from-table.html
    
    random_monster = self.find(:first, :offset => (self.count * rand).to_i)

    # We'll set the number of hitpoints for the monster to the max before unleashing
    # the freshly retrieved creature out on the world. Note, this is just a copy
    # of the database record. There could be dozens of these in the system all at
    # the same time. As long as none of them is saved back to the database each one
    # can be changed independently (e.g. taking damage), because you're only changing
    # the in-memory copy.
    random_monster.cur_hp = random_monster.max_hp
    
    random_monster
  end

  def alive?
    self.cur_hp > 0
  end
end
