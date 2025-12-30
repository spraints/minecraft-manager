class ConfigurationActivity < ApplicationRecord
  belongs_to :user
  belongs_to :configuration
end
