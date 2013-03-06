class AddIconToDefinition < ActiveRecord::Migration
  def change
    add_column :definitions, :icon, :string
  end
end
