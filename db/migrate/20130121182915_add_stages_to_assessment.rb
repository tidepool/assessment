class AddStagesToAssessment < ActiveRecord::Migration
  def change
    add_column :assessments, :stages, :text
  end
end
