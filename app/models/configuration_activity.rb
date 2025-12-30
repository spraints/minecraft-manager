class ConfigurationActivity < ApplicationRecord
  belongs_to :user
  belongs_to :configuration

  validates :user_id, :configuration_id, presence: true
  validates :action, presence: true, inclusion: %w( create apply )
end
