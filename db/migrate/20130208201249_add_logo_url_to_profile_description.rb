class AddLogoUrlToProfileDescription < ActiveRecord::Migration
  def change
    add_column :profile_descriptions, :logo_url, :string
  end
end
