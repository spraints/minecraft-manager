class AddActionToConfigurationActivity < ActiveRecord::Migration[8.1]
  def change
    add_column :configuration_activities, :action, :string, null: false
  end
end
