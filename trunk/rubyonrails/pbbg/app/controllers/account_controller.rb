class AccountController < ApplicationController
  def index
    @title = "PBBG - Welcome"

    current_user
    
    @atk = @user.get_stat('atk')
    @def = @user.get_stat('def')
    @mag = @user.get_stat('mag')
    @gc = @user.get_stat('gc')
    @curhp = @user.get_stat('curhp')
    @maxhp = @user.get_stat('maxhp')
  end

  def admin
    @title = "PBBG - Admin Page"
  end

  def login
    @title = "PBBG - Login"
    
    if request.post? and params[:user]
      @user = User.new(params[:user])
      
      user = User.find_by_username(@user.username)
      
      # If we found a user with that username and the password provided matches
      # the password on file for that user, we can login the user.
      if user and user.password_matches?(@user.password)
        session[:user_id] = user.id
        user.last_login = Time.now
        user.save

      if user.admin?
        redirect_to :action => "admin"
      else
        redirect_to :action => "index"
      end
     else
        flash[:notice] = "Sorry, no user was found with that username/password combination."
      end
    end
  end
  
  def logout
    session[:user_id] = nil
    redirect_to :action => "login"
  end

  def registration
    @title = "PBBG - Registration"
    
    if request.post? and params[:user]
      @user = User.new(params[:user])
      
      if @user.save
        session[:user_id] = @user.id

        flash[:notice] = "User created."
        redirect_to :action => "index"
      end
    end
  end
end
