class Configuration < ApplicationRecord
  belongs_to :parent, class_name: "Configuration"
  has_many :active_worlds, class_name: "ConfigurationActiveWorld"

  validates :state, inclusion: %w(proposed queued applied)
end
