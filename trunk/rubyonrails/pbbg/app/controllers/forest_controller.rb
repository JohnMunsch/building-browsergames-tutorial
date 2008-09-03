class ForestController < ApplicationController
  # We don't want anyone other than logged in users going to the forest.
  before_filter :login_required
  
  def index
    current_user
    
    @monster = Monster.random_encounter
  end
  
  def attack
  end
  
  def run_away
  end
end
