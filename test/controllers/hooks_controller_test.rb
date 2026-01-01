require "test_helper"

class HooksControllerTest < ActionController::TestCase
  setup do
    w = MinecraftWorld.create! \
      display_name: "anything",
      backend_addr: "anything:123"

    cfg = Configuration.create!(state: "proposed")
    @aw = cfg.active_worlds.create! \
      hostname: "example-world",
      world: w

    cfg.update!(state: "queued")
    cfg.update!(state: "applied")
  end

  test "empty hook body" do
    assert_no_changes "McRouterEvent.count" do
      post_webhook ""
      assert_response :unprocessable_entity
    end
  end

  test "not json" do
    assert_no_changes "McRouterEvent.count" do
      post_webhook "not json"
      assert_response :unprocessable_entity
    end
  end

  test "empty json" do
    assert_no_changes "McRouterEvent.count" do
      post_webhook "{}"
      assert_response :unprocessable_entity
    end
  end

  test "invalid date" do
    raw = <<-WEBHOOK
      {
        "event": "connect",
        "timestamp": "whooooooaaaa",
        "status": "success",
        "client": {
          "host": "127.0.0.1",
          "port": 56860
        },
        "server": "example-world",
        "player": {
          "name": "itzg",
          "uuid": "5cddfd26-fc86-4981-b52e-c42bb10bfdef"
        },
        "backend": "localhost:25566"
      }
    WEBHOOK
    assert_no_changes "McRouterEvent.count" do
      post_webhook raw
      assert_response :unprocessable_entity
    end
  end

  test "complete and active" do
    raw = <<-WEBHOOK
      {
        "event": "connect",
        "timestamp": "2025-04-20T22:26:30.2568775-05:00",
        "status": "success",
        "client": {
          "host": "127.0.0.1",
          "port": 56860
        },
        "server": "example-world",
        "player": {
          "name": "itzg",
          "uuid": "5cddfd26-fc86-4981-b52e-c42bb10bfdef"
        },
        "backend": "localhost:25566"
      }
    WEBHOOK
    post_webhook raw

    ev = McRouterEvent.order("id DESC").first
    refute_nil ev
    assert_equal "connect", ev.event
    # assert_equal "timestamp", something
    assert_equal "success", ev.status
    assert_equal "127.0.0.1", ev.client_host
    assert_equal 56860, ev.client_port
    assert_equal "example-world", ev.hostname
    assert_equal "itzg", ev.player_name
    assert_equal "5cddfd26-fc86-4981-b52e-c42bb10bfdef", ev.player_uuid
    assert_equal "localhost:25566", ev.backend_addr
    assert_equal @aw.id, ev.configuration_active_world_id
    assert_equal raw, ev.raw_payload
  end

  test "no player and active" do
    raw = <<-WEBHOOK
      {
        "event": "connect",
        "timestamp": "2025-04-20T22:26:30.2568775-05:00",
        "status": "success",
        "client": {
          "host": "127.0.0.1",
          "port": 56860
        },
        "server": "example-world",
        "backend": "localhost:25566"
      }
    WEBHOOK
    post_webhook raw

    ev = McRouterEvent.order("id DESC").first
    refute_nil ev
    assert_equal "connect", ev.event
    # assert_equal "timestamp", something
    assert_equal "success", ev.status
    assert_equal "127.0.0.1", ev.client_host
    assert_equal 56860, ev.client_port
    assert_equal "example-world", ev.hostname
    assert_nil ev.player_name
    assert_nil ev.player_uuid
    assert_equal "localhost:25566", ev.backend_addr
    assert_equal @aw.id, ev.configuration_active_world_id
    assert_equal raw, ev.raw_payload
  end

  test "complete and not active" do
    raw = <<-WEBHOOK
      {
        "event": "connect",
        "timestamp": "2025-04-20T22:26:30.2568775-05:00",
        "status": "success",
        "client": {
          "host": "127.0.0.1",
          "port": 56860
        },
        "server": "how-did-this-work-world",
        "player": {
          "name": "itzg",
          "uuid": "5cddfd26-fc86-4981-b52e-c42bb10bfdef"
        },
        "backend": "localhost:25566"
      }
    WEBHOOK
    post_webhook raw

    ev = McRouterEvent.order("id DESC").first
    refute_nil ev
    assert_equal "connect", ev.event
    # assert_equal "timestamp", something
    assert_equal "success", ev.status
    assert_equal "127.0.0.1", ev.client_host
    assert_equal 56860, ev.client_port
    assert_equal "how-did-this-work-world", ev.hostname
    assert_equal "itzg", ev.player_name
    assert_equal "5cddfd26-fc86-4981-b52e-c42bb10bfdef", ev.player_uuid
    assert_equal "localhost:25566", ev.backend_addr
    assert_nil ev.configuration_active_world_id
    assert_equal raw, ev.raw_payload
  end

  test "no player and not active" do
    raw = <<-WEBHOOK
      {
        "event": "connect",
        "timestamp": "2025-04-20T22:26:30.2568775-05:00",
        "status": "success",
        "client": {
          "host": "127.0.0.1",
          "port": 56860
        },
        "server": "how-did-this-work-world",
        "backend": "localhost:25566"
      }
    WEBHOOK
    post_webhook raw

    ev = McRouterEvent.order("id DESC").first
    refute_nil ev
    assert_equal "connect", ev.event
    # assert_equal "timestamp", something
    assert_equal "success", ev.status
    assert_equal "127.0.0.1", ev.client_host
    assert_equal 56860, ev.client_port
    assert_equal "how-did-this-work-world", ev.hostname
    assert_nil ev.player_name
    assert_nil ev.player_uuid
    assert_equal "localhost:25566", ev.backend_addr
    assert_nil ev.configuration_active_world_id
    assert_equal raw, ev.raw_payload
  end

  private

  def post_webhook(body)
    post "create", body: body.to_s
  end
end
