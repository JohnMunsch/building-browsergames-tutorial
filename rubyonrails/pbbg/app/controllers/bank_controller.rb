class BankController < ApplicationController
  def index
    current_user
  end

  def do_some_banking
    if params[:commit] == "Deposit"
      amount = current_user.deposit(params[:amount].to_i)

      flash[:notice] = "You deposited #{amount} gold into your bank account. Your total in the bank is now #{@current_user.bankgc}."
    else
      amount = current_user.withdraw(params[:amount].to_i)

      flash[:notice] = "You withdraw #{amount} gold from your bank account. Your total gold in hand is now #{@current_user.gold}."
    end

    render :action => "index"
  end
end
