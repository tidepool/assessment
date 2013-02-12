class IdentitiesController < ApplicationController
  def new
    @identity = env['omniauth.identity']
    if params['show_results']
      @submit_text = 'Show Results'
    else
      @submit_text = 'Register'
    end
  end
end
