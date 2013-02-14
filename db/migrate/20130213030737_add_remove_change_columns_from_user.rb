class AddRemoveChangeColumnsFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :uid
    remove_column :users, :provider
    rename_column :users, :anonymous, :guest
    add_column :users, :gender, :string
  end
end
