class ConfigurationActivator
  def self.queue!(configuration)
    configuration.class.transaction do
      configuration.update!(state: "queued")
      ActivateConfigurationJob.perform_later(configuration)
    end
  end

  def self.apply(configuration)
    # For now, set it back to proposed.
    configuration.update!(state: "proposed")
  end
end
