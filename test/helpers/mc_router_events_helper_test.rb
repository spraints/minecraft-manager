require "test_helper"

class McRouterEventsHelperTest < ActionView::TestCase
  test "client_for_event" do
    ev = McRouterEvent.create_from_json! <<-WEBHOOK, nil
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

    str = client_for_event(ev)
    assert_equal %{<<ec09fee4>>:56860}, str
    refute str.html_safe?, "string should be tainted so that the view escapes the bracketing"
  end
end
