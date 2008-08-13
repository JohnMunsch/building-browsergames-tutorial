class Monster < ActiveRecord::Base
  has_many :monster_stats
  has_many :stats, :through => :monster_stats
end
