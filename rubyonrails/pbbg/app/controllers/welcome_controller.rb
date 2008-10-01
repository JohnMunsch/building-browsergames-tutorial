class WelcomeController < ApplicationController
  skip_before_filter :login_required

  def index
    # Call the function current_user to get the user assigned to the 
    # @current_user variable (if anyone is logged in). The
    # function comes with restful_authentication.
    current_user
    
    @title = "Welcome"
  end
end
