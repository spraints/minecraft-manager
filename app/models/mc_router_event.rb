class McRouterEvent < ApplicationRecord
  belongs_to :configuration_active_world,
    -> { includes :configuration, :world },
    optional: true
end
