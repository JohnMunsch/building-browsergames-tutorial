class Monster < ActiveRecord::Base
  def self.random_encounter
    Monster.find_by_name('Crazy Eric')
  end
end
