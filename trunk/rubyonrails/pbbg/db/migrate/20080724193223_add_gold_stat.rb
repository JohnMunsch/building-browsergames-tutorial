class AddGoldStat < ActiveRecord::Migration
  def self.up
    Stat.create(:display_name => 'Gold', :short_name => 'gc')  
  end

  def self.down
    Stat.find_by_short_name('gc').destroy
  end
end
