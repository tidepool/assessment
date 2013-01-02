class SessionsController < ApplicationController
  def new
  end

  def create
    anonymous_user = current_user
    user = User.from_omniauth(env["omniauth.auth"], anonymous_user)
    session[:user_id] = user.id
    redirect_to root_url, notice: "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end

  def failure
    redirect_to root_url, alert: "Authentication failed, please try again."
  end
end
