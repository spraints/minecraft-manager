class ConfigurationActivator
  def self.queue!(configuration)
    configuration.class.transaction do
      configuration.update!(state: "queued")
      ActivateConfigurationJob.perform_later(configuration)
    end
  end

  def self.apply(configuration)
    mappings = {}
    configuration.active_worlds.each do |aw|
      mappings[aw.hostname] = aw.world.backend_addr
    end
    dest_path = Rails.application.config.mc_router_config_path
    mcrouter_config = JSON.dump({mappings: mappings})
    if ok_to_apply?(configuration)
      File.write dest_path, mcrouter_config
    end
    configuration.update!(state: "applied")
  rescue
    configuration.update!(state: "proposed")
    raise
  end

  private

  def self.ok_to_apply?(configuration)
    return false if configuration.state != "queued"
    if curr = Configuration.current
      return false if configuration.parent_id != curr.id
    else
      return false if configuration.parent_id.present?
    end
    true
  end
end
