class AssessmentStartController < ApplicationController
  before_filter :ensure_user

  def new
    definition = Definition.find_or_return_default(params[:def_id])
    if session[:assessment_id]
      @assessment = Assessment.find(session[:assessment_id])
    else
      @assessment = Assessment.find_or_create_by_definition_and_user(definition, current_user)
      session[:def_id] = params[:def_id]
      session[:assessment_id] = @assessment.id
    end
  end

  private
  def ensure_user
    if self.current_user.nil?
      self.current_user = User.create_guest
    end
  end
end
