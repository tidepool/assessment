class SessionsController < ApplicationController
  def new
  end

  def create
    anonymous_user = current_user
    user = User.from_omniauth(env["omniauth.auth"], anonymous_user)
    session[:user_id] = user.id
    cookies[:user_anonymous] = user.anonymous
    redirect_to redirect_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to redirect_url
  end

  def failure
    redirect_to login_url, alert: "Authentication failed, please try again."
  end

  private

  def redirect_url
    redirect_url = root_url
    if cookies["current_stage"] 
      current_stage = cookies["current_stage"]
      redirect_url = "#{redirect_url}#stage/#{current_stage}"
    end
    redirect_url    
  end
end
