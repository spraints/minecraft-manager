class CreateConfigurationActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :configuration_activities do |t|
      t.belongs_to :user, null: false
      t.belongs_to :configuration, null: false

      t.timestamps
    end
  end
end
