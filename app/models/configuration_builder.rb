class ConfigurationBuilder
  def self.prepare(current)
    config = Configuration.new(parent: current, state: "proposed")
    config_worlds = []
    by_id = {}
    MinecraftWorld.all.each do |w|
      cw = World.new(w)
      config_worlds << cw
      by_id[w.id] = cw
    end
    if current
      current.active_worlds.each do |aw|
        by_id[aw.minecraft_world_id].enabled = true
        by_id[aw.minecraft_world_id].hostname = aw.hostname
      end
    end
    [config, config_worlds]
  end

  # World is a model that represents a MinecraftWorld that may or may not be
  # included as a ConfigurationActiveWorld.
  class World
    include ActiveModel::API

    def initialize(minecraft_world)
      @minecraft_world = minecraft_world
    end

    attr_accessor :enabled, :hostname

    def id
      @minecraft_world.id
    end

    def world
      @minecraft_world
    end
  end
end
