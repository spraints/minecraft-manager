class CreateConfigurations < ActiveRecord::Migration[8.1]
  def change
    create_table :configurations do |t|
      t.string :state, null: false
      t.references :parent

      t.timestamps
    end
  end
end
