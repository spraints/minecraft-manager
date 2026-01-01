require "test_helper"

class ConfigurationBuilderTest < ActiveSupport::TestCase
  setup do
    @world1 = MinecraftWorld.create! \
      display_name: "world1",
      backend_addr: "127.0.0.1:25001"
    @world2 = MinecraftWorld.create! \
      display_name: "world2",
      backend_addr: "127.0.0.1:25002"
  end

  test "first configuration" do
    world_params = {
      @world1.id => {enabled: true, hostname: "host1"},
      @world2.id => {enabled: false, hostname: "host2"},
    }
    c = ConfigurationBuilder.build_from_params(params(worlds: world_params))
    assert_nil c.parent_id
    assert_equal "proposed", c.state
    assert_equal 1, c.active_worlds.size
    assert_equal @world1.id, c.active_worlds[0].minecraft_world_id
    assert_equal "host1", c.active_worlds[0].hostname
    assert c.valid?
  end

  def params(parent_id: nil, state: "proposed", worlds: {})
    ActionController::Parameters.new({
      "configuration" => {
        "parent_id" => parent_id.nil? ? "" : parent_id.to_s,
        "state" => "proposed",
        "configuration_builder_world" => worlds.map { |id, wp|
          [ id.to_s,
            {
              "enabled" => wp.fetch(:enabled, false) ? "1" : "0",
              "hostname" => wp.fetch(:hostname, ""),
            } ]
        }.to_h,
      },
    })
  end
end
