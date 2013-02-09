class AddResultsReadyToAssessment < ActiveRecord::Migration
  def change
    add_column :assessments, :results_ready, :boolean
    add_column :assessments, :results, :text
  end
end
