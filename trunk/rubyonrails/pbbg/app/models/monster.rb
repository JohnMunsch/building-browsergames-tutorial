class Monster < ActiveRecord::Base
  def self.random_encounter
    # For a single random record I'm using the technique from here:
    # http://robzon.aenima.pl/2007/12/selecting-random-row-from-table.html
    
    self.find(:first, :offset => (self.count * rand).to_i)
  end
end
