class AddStatsAndExampleMonsters < ActiveRecord::Migration
  def self.up
    # Create some new stats which we are just about to start using.
    max_hp = Stat.create(:display_name => 'Maximum HP', :short_name => 'maxhp')
    Stat.create(:display_name => 'Current HP', :short_name => 'curhp')

    # Get some additional stats we will be setting on our monsters.
    attack = Stat.find_by_short_name('atk')
    defense = Stat.find_by_short_name('def')
    gold = Stat.find_by_short_name('gc')

    # Create some example monsters.
    crazy_eric = Monster.create(:name => 'Crazy Eric')
    crazy_eric.monster_stats.create(:stat => attack, :value => 2)
    crazy_eric.monster_stats.create(:stat => defense, :value => 2)
    crazy_eric.monster_stats.create(:stat => max_hp, :value => 8)
    crazy_eric.monster_stats.create(:stat => gold, :value => 5)
    
    lazy_russell = Monster.create(:name => 'Lazy Russell')
    lazy_russell.monster_stats.create(:stat => attack, :value => 1)
    lazy_russell.monster_stats.create(:stat => defense, :value => 0)
    lazy_russell.monster_stats.create(:stat => max_hp, :value => 4)
    lazy_russell.monster_stats.create(:stat => gold, :value => 20)

    hard_hitting_louis = Monster.create(:name => 'Hard Hitting Louis')
    hard_hitting_louis.monster_stats.create(:stat => attack, :value => 4)
    hard_hitting_louis.monster_stats.create(:stat => defense, :value => 3)
    hard_hitting_louis.monster_stats.create(:stat => max_hp, :value => 10)
    hard_hitting_louis.monster_stats.create(:stat => gold, :value => 5)
  end

  def self.down
    Monster.find_by_name('Hard Hitting Louis').destroy
    Monster.find_by_name('Lazy Russell').destroy
    Monster.find_by_name('Crazy Eric').destroy
    
    Stat.find_by_short_name('curhp').destroy
    Stat.find_by_short_name('maxhp').destroy
  end
end
