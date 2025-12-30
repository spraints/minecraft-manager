class CreateMinecraftWorlds < ActiveRecord::Migration[8.1]
  def change
    create_table :minecraft_worlds do |t|
      t.string :display_name, null: false
      t.string :backend_addr, null: false

      t.timestamps
    end
  end
end
