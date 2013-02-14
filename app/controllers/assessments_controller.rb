class AssessmentsController < ApplicationController
	respond_to :json
	before_filter :ensure_user

	def index
	end

	def show 
		@assessment = Assessment.find(params[:id])
		if @assessment.user != current_user
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
			assessment.user = current_user
			assessment.definition = @definition
			assessment.stages = @definition.stages_from_stage_definition
			assessment.date_taken = DateTime.now
			assessment.status = 0
			assessment.results_ready = false
		end
		cookies[:assessment_id] = @assessment.id
    cookies[:current_stage] = 0
		respond_with @assessment
	end

	def update
	end

	private
	def ensure_user
		if current_user.nil?
      current_user = User.create_guest
    end
	end
end
