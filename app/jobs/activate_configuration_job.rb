class ActivateConfigurationJob < ApplicationJob
  queue_as :default

  def perform(config)
    ConfigurationActivator.apply(config)
  end
end
