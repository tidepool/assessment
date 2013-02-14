class UsersController < ApplicationController
  def new
    @user = env['omniauth.identity']
    if params['show_results']
      @submit_text = 'Show Results'
    else
      @submit_text = 'Register'
    end
  end
end
