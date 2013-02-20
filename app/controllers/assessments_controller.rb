class AssessmentsController < ApplicationController
	respond_to :json

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
            format.json { render :json => @assessment}
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
		@assessment = Assessment.create_with_definition(params[:def_id])
    #cookies[:assessment_id] = @assessment.id
    #cookies[:current_stage] = 0
		respond_with @assessment
	end

	def update
	end

end
