class RemoveEmailPasswordDigestGenderFromIdentity < ActiveRecord::Migration
  def change
    remove_column :identities, :password_digest
    remove_column :identities, :gender
    remove_column :identities, :email
    remove_column :identities, :name
  end

end
