class Configuration < ApplicationRecord
  belongs_to :parent, class_name: "Configuration", optional: true
  has_many :active_worlds, class_name: "ConfigurationActiveWorld"

  validates :state, inclusion: %w[proposed queued applied]

  def self.current
    where(state: "applied").order("id DESC").first
  end
end
