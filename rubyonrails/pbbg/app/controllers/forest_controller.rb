class ForestController < ApplicationController
  def index
    current_user
    
    # Get a random monster for us to encounter in the forest.
    @monster = Monster.random_encounter
    
    # Save the monster in our session.
    session[:monster_id] = @monster.id
  end
  
  def attack
    current_user
    
    # Pull the monster we were fighting from the session.
    @monster = Monster.find(session[:monster_id])
    
    # Fight the monster and get the transcript of the fight.
    @combat = @current_user.fight(@monster)
  end
  
  # Running away couldn't be much easier, just send the user back to the welcome page.
  def run_away
    session[:monster_id] = nil
    
    redirect_to :controller => "welcome"
  end
end
