class Configuration < ApplicationRecord
  belongs_to :parent, class_name: "Configuration", optional: true
  has_many :active_worlds, class_name: "ConfigurationActiveWorld"

  validates :state, inclusion: { in: :valid_next_states }
  validate :validate_parentage_is_linear

  def valid_next_states
    case
    when new_record?
      %w[ proposed ]
    when state_was == "proposed"
      %w[ proposed queued ]
    when state_was == "queued"
      %w[ proposed queued applied ]
    when state_was == "applied"
      %w[ applied retired ]
    when state_was == "retired"
      %w[ retired ]
    else
      raise "illegal initial state #{state_was}"
    end
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

  def edit_ok?
    state == "proposed"
  end

  def apply_ok?
    state == "proposed"
  end
end
