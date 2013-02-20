class AddStageCompletedToAssessment < ActiveRecord::Migration
  def change
    add_column :assessments, :stage_completed, :integer
  end
end
