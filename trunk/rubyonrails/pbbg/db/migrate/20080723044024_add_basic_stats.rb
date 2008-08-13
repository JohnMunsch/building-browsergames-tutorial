class AddBasicStats < ActiveRecord::Migration
  def self.up
    Stat.create(:display_name => 'Magic', :short_name => 'mag')
    Stat.create(:display_name => 'Attack', :short_name => 'atk')
    Stat.create(:display_name => 'Defense', :short_name => 'def')
  end

  def self.down
    Stat.find_by_short_name('def').destroy
    Stat.find_by_short_name('atk').destroy
    Stat.find_by_short_name('mag').destroy
  end
end
