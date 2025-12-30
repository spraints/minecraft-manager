class Configuration < ApplicationRecord
  belongs_to :parent, class_name: "Configuration"
  has_many :active_worlds, class_name: "ConfigurationActiveWorld"
  belongs_to :created_by, class_name: "User"
  belongs_to :applied_by, class_name: "User"
end
