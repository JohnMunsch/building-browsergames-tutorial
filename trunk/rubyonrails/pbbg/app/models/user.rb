require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login,    :case_sensitive => false
  validates_format_of       :login,    :with => RE_LOGIN_OK, :message => MSG_LOGIN_BAD

  validates_format_of       :name,     :with => RE_NAME_OK,  :message => MSG_NAME_BAD, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email,    :case_sensitive => false
  validates_format_of       :email,    :with => RE_EMAIL_OK, :message => MSG_EMAIL_BAD

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def alive?
    self.cur_hp > 0
  end

  def fight(monster)
    combat = Array.new
    
    turn_number = 0
    
    # This is a small workaround for the fact that we aren't 
    # getting the user's name yet when they signup. All we 
    # have for the user is the login.
    if (self.name.empty?)
      self.name = self.login
    end
    
    while (self.alive? and monster.alive?)
      turn_number += 1
      
      # Switch the roles of attacker and defender back and forth.
      if (turn_number % 2 != 0)
        attacker = monster
        defender = self
      else
        attacker = self
        defender = monster
      end
      
      if (attacker.attack > defender.defense)
        damage = attacker.attack - defender.defense
        
        # We allow damage to take you below zero hitpoints. Presumably 
        # the funeral is closed casket in those cases.
        defender.cur_hp -= damage

        # We'll only make a turn record for those cases where 
        # something actually happens.
        turn = Hash.new
        turn["attacker"] = attacker.name
        turn["defender"] = defender.name
        turn["damage"] = damage
        
        # Save this turn in the combat transcript.
        combat << turn
      end
    end
    
    # Somebody is dead, let's see who and take appropriate action.
    if (self.alive?)
      # Yay, you lived. You get gold.
      self.gold += monster.gold
    else
      # There aren't any penalties for losing at the moment.
    end

    # We only save the user's record back to the database. The monster needs to
    # stay unchanged in the database no matter how much damage we did to it so
    # the next one we make will still be pristine.
    self.save
    
    # Return the results of combat.
    combat
  end

  def deposit(amount)
    if (amount < 0 or amount > self.gold)
      amount = self.gold
    end

    self.bankgc += amount
    self.gold -= amount
    self.save
    
    amount
  end

  def withdraw(amount)
    if (amount < 0 or amount > self.bankgc)
      amount = self.bankgc
    end

    self.bankgc -= amount
    self.gold += amount
    self.save
    
    amount
  end

  def heal(amount)
    if (amount < 0 or amount > self.gold)
      amount = self.gold
    end
    
    if (amount > (self.max_hp - self.cur_hp))
      amount = self.max_hp - self.cur_hp
    end
    
    self.gold -= amount
    self.cur_hp += amount
    self.save
    
    amount
  end
  
  protected
  
  def before_create
    self.attack = 5
    self.defense = 5
    self.magic = 5
  end
end
