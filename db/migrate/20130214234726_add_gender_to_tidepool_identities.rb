class AddGenderToTidepoolIdentities < ActiveRecord::Migration
  def change
    add_column :tidepool_identities, :gender, :string
  end
end
