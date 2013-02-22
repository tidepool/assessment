class AddExperimentToDefinition < ActiveRecord::Migration
  def change
    add_column :definitions, :experiment, :string
  end
end
