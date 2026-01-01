class ConfigurationBuilder
  def self.prepare(current)
    config = Configuration.new(parent: current, state: "proposed")
    config_worlds = prepare_worlds(current)
    [config, config_worlds]
  end

  def self.prepare_worlds(config)
    config_worlds = []
    by_id = {}
    MinecraftWorld.all.each do |w|
      cw = World.new(w)
      config_worlds << cw
      by_id[w.id] = cw
    end
    if config
      config.active_worlds.each do |aw|
        by_id[aw.minecraft_world_id].enabled = true
        by_id[aw.minecraft_world_id].hostname = aw.hostname
      end
    end
    config_worlds
  end

  def self.build_from_params(params)
    cfg_params = params[:configuration]
    c = Configuration.new(cfg_params.permit(:parent_id, :state))
    cfg_params[:configuration_builder_world].each do |key, wparams|
      if wparams[:enabled] == "1"
        c.active_worlds.build \
          minecraft_world_id: key,
          hostname: wparams[:hostname]
      end
    end
    c
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
