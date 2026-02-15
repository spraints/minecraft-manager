class ConfigurationActivator
  class Error < StandardError; end

  class IllegalState < Error; end
  class MissingEnv < Error; end
  class ParentNotCurrent < Error; end

  def self.queue!(configuration)
    configuration.class.transaction do
      configuration.update!(state: "queued")
      ActivateConfigurationJob.perform_later(configuration)
    end
  end

  def self.apply(configuration)
    if configuration.state != "queued"
      raise IllegalState, "configuration is in the wrong state (#{configuration.state.inspect})"
    end

    dest_path = Rails.application.config.mc_router_config_path
    raise MissingEnv, "Missing MC_ROUTES environment variable" if dest_path.blank?

    begin
      Configuration.transaction do
        retire_parent parent_id: configuration.parent_id
        unless Configuration.current.nil?
          raise ParentNotCurrent,
            "error applying configuration #{configuration.id}: after retiring its parent, configuration##{Configuration.current.id} is still in effect"
        end

        applied = Configuration.queued.where(id: configuration.id).update_all \
          updated_at: Time.now,
          state: "applied"
        if applied != 1
          raise IllegalState, "configuration state changed in a race"
        end

        File.write dest_path, render(configuration)
      end
    rescue Error
      configuration.update(state: "proposed")
      raise
    end
  end

  private

  def self.render(configuration)
    mappings = {}
    configuration.active_worlds.each do |aw|
      mappings[aw.hostname] = aw.world.backend_addr
    end
    JSON.dump({ mappings: mappings })
  end

  def self.retire_parent(parent_id:)
    to_retire = Configuration.applied
    expected_retirements = 0
    if parent_id.present?
      to_retire = to_retire.where(id: parent_id)
      expected_retirements = 1
    end

    updated = to_retire.update_all \
      updated_at: Time.now,
      state: "retired"
    if updated != expected_retirements
      raise ParentNotCurrent, "expected to retire #{expected_retirements} configurations, but found #{updated} matching parent configurations"
    end
  end
end
