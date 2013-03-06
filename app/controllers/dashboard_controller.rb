class DashboardController < ApplicationController
  def show
    @assessments = Assessment.includes(:definition).where('user_id = ?', current_user.id).order(:date_taken).all
    @user = User.includes(:profile_description).where('id = ?', current_user.id).first
  end
end
