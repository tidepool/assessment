class AssessmentStartController < ApplicationController
  before_filter :ensure_user

  def new
    definition = Definition.find_or_return_default(params[:def_id])
    @assessment = Assessment.find_or_create_by_definition_and_user(definition, current_user)
    session[:assessment_id] = @assessment.id
  end

  def show
    if session[:assessment_id]
      @assessment = Assessment.find(session[:assessment_id])
    else
      render :file => "#{Rails.root}/public/404.html",  :status => 404
    end
  end

  private
  def ensure_user
    if self.current_user.nil?
      self.current_user = User.create_guest
    end
  end
end
