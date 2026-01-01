class ActivateConfigurationJob < ApplicationJob
  queue_as :default

  limits_concurrency to: 1, duration: 10.minutes, key: ->(_) { "__all__" }

  def perform(config)
    ConfigurationActivator.apply(config)
  end
end
