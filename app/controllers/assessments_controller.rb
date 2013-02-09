class AssessmentsController < ApplicationController
	respond_to :json
	before_filter :ensure_user

	def index
	end

	def show 
		@assessment = Assessment.includes(:profile_description).find(params[:id])
		if @assessment.user != @user
			respond_to do |format|
				format.json { render :json => {}, :status => :unauthorized }
			end
		else
			if params[:results]
				if @assessment.results_ready?
          respond_to do |format|
            format.json { render :json => @assessment.to_json(:include => :profile_description)}
          end
				else
					respond_to do |format|
						format.json { render :json => {}, :status => :partial_content}
					end
				end
			else
				respond_with @assessment
			end
		end
	end

	def create
		@definition = Definition.find_or_return_default(params[:def_id])
		@assessment = Assessment.create! do |assessment| 
			assessment.user = @user
			assessment.definition = @definition
			assessment.stages = @definition.stages_from_stage_definition
			assessment.date_taken = DateTime.now
			assessment.status = 0
			assessment.results_ready = false
		end
		cookies[:assessment_id] = @assessment.id

		respond_with @assessment
	end

	def update
	end

	private
	def ensure_user
		@user = current_user || User.create_anonymous
		session[:user_id] = @user.id
		cookies[:user_anonymous] = @user.anonymous
	end
end
