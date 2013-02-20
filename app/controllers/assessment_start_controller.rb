class AssessmentStartController < ApplicationController
  before_filter :ensure_user

  def new
		@definition = Definition.find_or_return_default(params[:def_id])
    @assessment = Assessment.create_with_definition(params[:def_id])
    @assessment.user = current_user
  end

  private
  def ensure_user
    if self.current_user.nil?
      self.current_user = User.create_guest
    end
  end
end
