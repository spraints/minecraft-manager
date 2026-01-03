class McRouterEvent < ApplicationRecord
  belongs_to :configuration_active_world,
    -> { includes :configuration, :world },
    optional: true

  def self.create_from_json!(raw, remote_ip)
    data = JSON.parse(raw)

    ev = McRouterEvent.new
    ev.event = data.fetch("event")
    ev.occurred_at = DateTime.parse(data.fetch("timestamp"))
    ev.status = data.fetch("status")
    ev.client_host = data.fetch("client").fetch("host")
    ev.client_port = data.fetch("client").fetch("port")
    ev.hostname = data.fetch("server")
    ev.player_name = data.dig("player", "name")
    ev.player_uuid = data.dig("player", "uuid")
    ev.backend_addr = data.fetch("backend")

    ev.sender_addr = remote_ip
    ev.raw_payload = raw

    if cur = Configuration.current
      ev.configuration_active_world = cur.active_worlds.where(hostname: ev.hostname).first
    end

    ev.save!
    ev
  end
end
