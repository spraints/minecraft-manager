class CreateConfigurations < ActiveRecord::Migration[8.1]
  def change
    create_table :configurations do |t|
      t.string :state
      t.references :parent
      t.references :created_by
      t.references :applied_by
      t.timestamp :queued_at
      t.timestamp :applied_at

      t.timestamps
    end
  end
end
