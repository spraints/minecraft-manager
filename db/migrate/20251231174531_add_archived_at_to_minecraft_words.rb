class AddArchivedAtToMinecraftWords < ActiveRecord::Migration[8.1]
  def change
    add_column :minecraft_worlds, :archived_at, :timestamp
  end
end
