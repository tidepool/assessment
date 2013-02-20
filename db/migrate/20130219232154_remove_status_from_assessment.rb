class RemoveStatusFromAssessment < ActiveRecord::Migration
  def up
    remove_column :assessments, :status
  end

  def down
    add_column :assessments, :status, :integer
  end
end
