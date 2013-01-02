class AssessmentStartController < ApplicationController
	def new
		@definition = Definition.find_or_return_default(params[:def_id])
    logger.info "hello World!!!!!!!!!"
	end
end
