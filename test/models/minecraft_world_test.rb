require "test_helper"

class MinecraftWorldTest < ActiveSupport::TestCase
  setup do
    @lonely_world = MinecraftWorld.create! \
      display_name: "not in a config",
      backend_addr: "127.0.0.1:5555"

    @pending_world = MinecraftWorld.create! \
      display_name: "in a pending config",
      backend_addr: "127.0.0.1:6666"

    @old_world = MinecraftWorld.create! \
      display_name: "previously in a config",
      backend_addr: "127.0.0.1:7777"

    @active_world = MinecraftWorld.create! \
      display_name: "currently in a config",
      backend_addr: "127.0.0.1:8888"

    c1 = Configuration.create! state: "applied"
    ConfigurationActiveWorld.create! \
      configuration: c1,
      hostname: "old-world",
      world: @old_world

    c2 = Configuration.create! state: "applied", parent: c1
    ConfigurationActiveWorld.create! \
      configuration: c2,
      hostname: "active-world",
      world: @active_world

    @pending_config = Configuration.create! state: "proposed", parent: c2
    ConfigurationActiveWorld.create! \
      configuration: @pending_config,
      hostname: "pending",
      world: @pending_world
  end

  test "lonely world configuration state when no configurations exist" do
    Configuration.delete_all
    assert_equal :absent, @lonely_world.configuration_state
  end

  test "lonely world configuration state" do
    assert_equal :absent, @lonely_world.configuration_state
  end

  test "lonely world can edit display name" do
    @lonely_world.update!(display_name: "new name")
    assert_equal "new name", @lonely_world.reload.display_name
  end

  test "lonely world can edit backend addr" do
    @lonely_world.update!(backend_addr: "127.0.0.1:4444")
    assert_equal "127.0.0.1:4444", @lonely_world.reload.backend_addr
  end

  test "lonely world can archive" do
    @lonely_world.archive!
    assert_raises ActiveRecord::RecordNotFound do
      MinecraftWorld.find(@lonely_world.id)
    end
    assert_nothing_raised do
      MinecraftWorld.archived.find(@lonely_world.id)
    end
  end

  test "lonely world can destroy" do
    @lonely_world.destroy!
    assert_raises ActiveRecord::RecordNotFound do
      MinecraftWorld.unscoped.find(@lonely_world.id)
    end
  end

  test "pending world configuration state" do
    assert_equal :pending, @pending_world.configuration_state
  end

  test "pending world configuration state when only pending configuration exists" do
    Configuration.where("id <> #{@pending_config.id}").delete_all
    assert_equal :pending, @pending_world.configuration_state
  end

  test "pending world can edit display name" do
    @pending_world.update!(display_name: "new name")
    assert_equal "new name", @pending_world.reload.display_name
  end

  test "pending world can not edit backend addr" do
    assert_raises ActiveRecord::RecordInvalid do
      @pending_world.update!(backend_addr: "127.0.0.1:4444")
    end
  end

  test "pending world can not archive" do
    assert_raises ActiveRecord::RecordInvalid do
      @pending_world.archive!
    end
  end

  test "pending world can not destroy" do
    assert_raises ActiveRecord::RecordNotDestroyed do
      @pending_world.destroy!
    end
  end

  test "old world configuration state" do
    assert_equal :inactive, @old_world.configuration_state
  end

  test "old world can edit display name" do
    @old_world.update!(display_name: "new name")
    assert_equal "new name", @old_world.reload.display_name
  end

  test "old world can not edit backend addr" do
    assert_raises ActiveRecord::RecordInvalid do
      @old_world.update!(backend_addr: "127.0.0.1:4444")
    end
  end

  test "old world can archive" do
    @old_world.archive!
    assert_raises ActiveRecord::RecordNotFound do
      MinecraftWorld.find(@old_world.id)
    end
    assert_nothing_raised do
      MinecraftWorld.archived.find(@old_world.id)
    end
  end

  test "old world can not destroy" do
    assert_raises ActiveRecord::RecordNotDestroyed do
      @old_world.destroy!
    end
  end

  test "active world configuration state" do
    assert_equal :active, @active_world.configuration_state
  end

  test "active world can edit display name" do
    @active_world.update!(display_name: "new name")
    assert_equal "new name", @active_world.reload.display_name
  end

  test "active world can not edit backend addr" do
    assert_raises ActiveRecord::RecordInvalid do
      @active_world.update!(backend_addr: "127.0.0.1:4444")
    end
  end

  test "active world can not archive" do
    assert_raises ActiveRecord::RecordInvalid do
      @active_world.archive!
    end
  end

  test "active world can not destroy" do
    assert_raises ActiveRecord::RecordNotDestroyed do
      @active_world.destroy!
    end
  end
end
