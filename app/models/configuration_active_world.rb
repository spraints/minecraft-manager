class ConfigurationActiveWorld < ApplicationRecord
  belongs_to :configuration
  belongs_to :world, class_name: "MinecraftWorld", foreign_key: "minecraft_world_id"

  validates :hostname, presence: true
  validates :minecraft_world_id, presence: true
end
