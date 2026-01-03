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
    McRouterEvent.create_from_json!(raw, request.remote_ip)

    head :accepted
  rescue Date::Error, KeyError => e
    Rails.logger.info "INVALID WEBHOOK: #{e.class}: #{e}"
    head :unprocessable_entity
  rescue JSON::ParserError
    head :unprocessable_entity
  end
end
