class ConfigurationActiveWorld < ApplicationRecord
  belongs_to :configuration
  belongs_to :world, class_name: "MinecraftWorld"

  validates :hostname, presence: true
  validates :world_id, presence: true
end
