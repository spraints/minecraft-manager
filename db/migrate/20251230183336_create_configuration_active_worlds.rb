class CreateConfigurationActiveWorlds < ActiveRecord::Migration[8.1]
  def change
    create_table :configuration_active_worlds do |t|
      t.references :configuration, null: false
      t.references :world, null: false
      t.string :hostname, null: false

      t.timestamps
    end
  end
end
