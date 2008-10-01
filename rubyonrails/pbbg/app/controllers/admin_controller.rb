class AdminController < ApplicationController
  def index
  end

  private
  
  # By adding a function named "authorized?" and performing a test in it
  # we use one of the hooks provided by restful_authentication.
  def authorized?
    current_user.login == "Admin"
  end  
end
