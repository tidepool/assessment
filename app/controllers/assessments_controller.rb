class AssessmentsController < ApplicationController
	respond_to :json

	def index
		respond_with Assessment.all
	end

	def show 
		
	end

	def create
		@user = current_user || User.create_anonymous
		session[:user_id] = @user.id

		@definition = Definition.find_or_return_default(params[:def_id])
		@assessment = Assessment.create! do |assessment| 
			assessment.user = @user
			assessment.definition = @definition
			assessment.date_taken = DateTime.now
			assessment.status = 0
			assessment.anonymous = @user.anonymous
		end

		respond_with @assessment, :include => :definition
	end
	def update

	end
end
