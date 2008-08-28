class WelcomeController < ApplicationController
  def index
    # Call the function current_user to get the user assigned to the 
    # @current_user variable (if anyone is logged in). The
    # function comes with restful_authentication.
    current_user
  end
end
