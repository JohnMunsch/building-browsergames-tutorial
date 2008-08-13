class MonsterStat < ActiveRecord::Base
  belongs_to :monster
  belongs_to :stat
  
  validates_uniqueness_of :stat_id, :scope => :monster_id
end
