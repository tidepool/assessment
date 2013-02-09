class RemoveResultsFromAssessments < ActiveRecord::Migration
  def up
    remove_column :assessments, :results
  end

  def down
    add_column :assessments, :results, :text
  end
end
