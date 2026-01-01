class HooksController < ApplicationController
  protect_from_forgery with: :null_session
  allow_unauthenticated_access only: :create

  # See https://github.com/itzg/mc-router/blob/main/server/webhook_notifier.go
  # Example payload:
  # {
  #   "event": "connect",
  #   "timestamp": "2025-04-20T22:26:30.2568775-05:00",
  #   "status": "success",
  #   "client": {
  #     "host": "127.0.0.1",
  #     "port": 56860
  #   },
  #   "server": "localhost",
  #   "player": {
  #     "name": "itzg",
  #     "uuid": "5cddfd26-fc86-4981-b52e-c42bb10bfdef"
  #   },
  #   "backend": "localhost:25566"
  # }
  def create
    raw = request.raw_post
    Rails.logger.info "WEBHOOK RECEIVED from #{request.remote_ip}: #{raw}"
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

    ev.sender_addr = request.remote_ip
    ev.raw_payload = raw

    ev.configuration_active_world =
      Configuration.current.active_worlds.where(hostname: ev.hostname).first

    ev.save!

    head :accepted
  rescue Date::Error, KeyError => e
    Rails.logger.info "INVALID WEBHOOK: #{e.class}: #{e}"
    head :unprocessable_entity
  rescue JSON::ParserError
    head :unprocessable_entity
  end
end
