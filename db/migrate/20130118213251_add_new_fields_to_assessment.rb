class AddNewFieldsToAssessment < ActiveRecord::Migration
  def change
    add_column :assessments, :event_log, :text
    add_column :assessments, :intermediate_results, :text
  end
end
