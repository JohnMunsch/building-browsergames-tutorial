class Property < ActiveRecord::Base
  belongs_to :user
  belongs_to :stat
  
  validates_uniqueness_of :stat_id, :scope => :user_id
end
