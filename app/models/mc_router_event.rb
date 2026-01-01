class McRouterEvent < ApplicationRecord
  belongs_to :configuration_active_world, optional: true
end
