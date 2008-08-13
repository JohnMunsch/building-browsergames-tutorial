class Stat < ActiveRecord::Base
  has_many :properties
  has_many :users, :through => :properties
  has_many :monsters, :through => :monster_stats
end
