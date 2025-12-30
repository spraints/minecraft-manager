class ConfigurationActiveWorld < ApplicationRecord
  belongs_to :configuration
  belongs_to :world, class_name: "MinecraftWorld"
end
