class RemoveRawEventUrlFromAssessment < ActiveRecord::Migration
  def up
    remove_column :assessments, :raw_event_url
  end

  def down
    add_column :assessments, :raw_event_url, :string
  end
end
