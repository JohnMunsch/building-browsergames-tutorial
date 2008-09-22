class HealerController < ApplicationController
  def index
  end

  def do_some_healing
    # The amount we actually healed might be different than the amount requested
    # due to a variety of factors (i.e. they didn't need that much healing, they
    # didn't have enough gold, etc.) so we record the amount they actually healed
    # which comes back from the method call.
    amount = current_user.heal(params[:amount].to_i)

    flash[:notice] = "You have been healed for #{amount} HP."
    render :action => "index"
  end
end
