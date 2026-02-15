class ActivateConfigurationJob < ApplicationJob
  queue_as :default

  discard_on ConfigurationActivator::Error

  def perform(config)
    ConfigurationActivator.apply(config)
  end
end
