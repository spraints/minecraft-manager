class CreateMcRouterEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :mc_router_events do |t|
      t.string :event
      t.timestamp :occurred_at
      t.string :status
      t.string :client_host
      t.integer :client_port
      t.string :hostname
      t.string :player_name
      t.string :player_uuid
      t.string :backend_addr
      t.string :sender_addr
      t.string :raw_payload

      t.timestamps
    end
  end
end
