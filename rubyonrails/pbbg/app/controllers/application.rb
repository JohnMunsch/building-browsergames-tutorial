# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '6da6414aec9fe2aa101f6ebb026d00d6'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  # Default to security for all of our controllers and actions. Add a new controller
  # and it will be secure because it will inherit from the ApplicationController. In
  # order to override this setting we can add:
  #   skip_before_filter :login_required
  # or:
  #   skip_before_filter :login_required, :only => show  
  before_filter :login_required
end
