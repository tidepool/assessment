class RemoveAnonymousFromAssessment < ActiveRecord::Migration
  def change
    remove_column :assessments, :anonymous
  end
end
