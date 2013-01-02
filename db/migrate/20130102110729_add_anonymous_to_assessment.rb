class AddAnonymousToAssessment < ActiveRecord::Migration
  def change
    add_column :assessments, :anonymous, :string
  end
end
