class RemoveEmailPasswordDigestFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :email
    remove_column :users, :password_digest
  end

  def down
    add_column :users, :password_digest, :string
    add_column :users, :email, :string
  end
end
