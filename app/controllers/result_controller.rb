class ResultController < ApplicationController
  def new
  end

  def show
    @assessment = Assessment.find(params[:assessment_id])
  end

  def destroy
  end

  def create
  end
end
