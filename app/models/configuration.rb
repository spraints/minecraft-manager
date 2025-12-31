class Configuration < ApplicationRecord
  belongs_to :parent, class_name: "Configuration", optional: true
  has_many :active_worlds, class_name: "ConfigurationActiveWorld"

  validates :state, inclusion: %w[proposed queued applied]
  validate :validate_initial_state, on: :create
  validate :validate_parentage_is_linear

  def validate_initial_state
    errors.add :state, "must be proposed on new records" unless state == "proposed"
  end

  def validate_parentage_is_linear
    errors.add :parent_id, "must be earlier" unless new_record? || self.parent_id.nil? || self.parent_id < self.id
  end

  def self.current
    applied.order("id DESC").first
  end

  scope :proposed, -> { where(state: "proposed").order("id ASC") }
  scope :queued, -> { where(state: "queued") }
  scope :applied, -> { where(state: "applied").order("id DESC") }
end
