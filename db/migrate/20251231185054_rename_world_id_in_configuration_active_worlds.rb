class RenameWorldIdInConfigurationActiveWorlds < ActiveRecord::Migration[8.1]
  def change
    rename_column :configuration_active_worlds, :world_id, :minecraft_world_id
  end
end
