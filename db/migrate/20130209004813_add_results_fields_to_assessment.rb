class AddResultsFieldsToAssessment < ActiveRecord::Migration
  def change
    add_column :assessments, :profile_description_id, :integer
    add_column :assessments, :aggregate_results, :text
    add_column :assessments, :big5_dimension, :string
    add_column :assessments, :holland6_dimension, :string
    add_column :assessments, :emo8_dimension, :string
  end
end
