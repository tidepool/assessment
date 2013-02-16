class CreateTidepoolIdentities < ActiveRecord::Migration
  def change
    create_table :tidepool_identities do |t|
      t.string :email
      t.string :password_digest
      t.string :name

      t.timestamps
    end
  end
end
