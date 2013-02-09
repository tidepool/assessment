class CreateProfileDescriptions < ActiveRecord::Migration
  def change
    create_table :profile_descriptions do |t|
      t.string :name
      t.text :description
      t.string :one_liner
      t.text :bullet_description
      t.string :big5_dimension
      t.string :holland6_dimension
      t.string :code

      t.timestamps
    end
  end
end
