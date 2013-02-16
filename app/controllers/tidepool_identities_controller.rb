class TidepoolIdentitiesController < ApplicationController
  def new
    @tidepool_identity = env['omniauth.identity']
    if params['show_results']
      @submit_text = 'Show Results'
    else
      @submit_text = 'Register'
    end
  end
end
