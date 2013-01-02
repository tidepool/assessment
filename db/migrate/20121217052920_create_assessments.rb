class CreateAssessments < ActiveRecord::Migration
  def change
    create_table :assessments do |t|
      t.date :date_taken
      t.string :score
      t.string :raw_event_url
      t.integer :status
      t.references :definition	
      t.references :user

      t.timestamps
    end
  end
end
