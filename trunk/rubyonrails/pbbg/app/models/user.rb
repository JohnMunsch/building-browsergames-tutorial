require "digest"

class User < ActiveRecord::Base
  validates_uniqueness_of :username, :case_sensitive => false
  validates_presence_of :password
  validates_confirmation_of :password
  
  has_many :properties
  has_many :stats, :through => :properties
  
  def get_stat(statname)
    stat = find_stat_by_name(statname)

    property = self.properties.find_or_create_by_stat_id(:stat_id => stat.id, :value => 0)
    property.value
  end
  
  def set_stat(statname, value)
    stat = find_stat_by_name(statname)

    property = self.properties.find_or_create_by_stat_id(:stat_id => stat.id)
    property.value = value
    property.save
  end

  def find_stat_by_name(statname)
    stat = Stat.find_by_display_name(statname)
    stat ||= Stat.find_by_short_name(statname)    
  end
  
  # Setup the salt value and hash the password before we save everything to the
  # database.
  def before_save
    if (self.salt == nil)
      self.salt = random_numbers(5)
      self.password = Digest::MD5.hexdigest(self.salt + self.password)
    end
  end
  
  # Since this will end up putting records into the Properties table, 
  # we will wait until after the user is saved and has an ID value 
  # before adding stats to him/her.
  def after_create
    self.properties.create(:stat => find_stat_by_name('atk'), :value => 5)
    self.properties.create(:stat => find_stat_by_name('def'), :value => 5)
    self.properties.create(:stat => find_stat_by_name('mag'), :value => 5)
  end
  
  def password_matches?(password_to_match)
    self.password == Digest::MD5.hexdigest(self.salt + password_to_match)
  end
  
  private
  
  # A sequence of random numbers with no skewing of range in any particular
  # direction and leading zeros preserved.
  def random_numbers(len)
    numbers = ("0".."9").to_a
    newrand = ""
    1.upto(len) { |i| newrand << numbers[rand(numbers.size - 1)] }
    return newrand
  end
end
