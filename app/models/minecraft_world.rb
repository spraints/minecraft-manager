class MinecraftWorld < ApplicationRecord
  has_many :configuration_worlds, class_name: "ConfigurationActiveWorld"
  has_many :configurations, through: :configuration_worlds

  scope :archived, -> { unscoped.where("archived_at IS NOT NULL") }
  default_scope { where("archived_at IS NULL" ) }

  validates :display_name, presence: true
  validates :backend_addr, presence: true, format: { with: /\A([^:]+):(\d+)\z/ }

  validate :protected_attrs, except_on: :create
  before_destroy :only_destroy_absent

  def protected_attrs
    cs = configuration_state
    return if cs == :absent
    # This server has been included in a configuration at least once.
    errors.add :backend_addr, "cannot be changed after use" if backend_addr_changed?
    return if cs == :inactive
    # This server is in a pending or active configuration.
    errors.add :archived_at, "cannot be set while server is in #{cs} configuration" unless archived_at.nil?
  end

  def only_destroy_absent
    if configuration_worlds.any?
      errors.add :base, "cannot be destroyed after use"
      throw :abort
    end
  end

  # Returns one of the following symbols:
  # :absent - not included in any ConfigurationActiveWorld.
  # :active - is in the the current active configuration.
  # :pending - is not active but is in a configuration that could become active.
  # :inactive - is in a previous configuration, but not an active or pending one.
  def configuration_state
    cc = Configuration.current
    if cc.active_worlds.any? { |aw| aw.minecraft_world_id == id }
      return :active
    end
    cw = configuration_worlds
    if cw.any? { |cw| cw.configuration_id > cc.id }
      return :pending
    end
    if cw.empty?
      return :absent
    end
    :inactive
  end

  def archive
    return true if self.archived_at.present?
    self.archived_at = Time.now
    self.save
  end

  def archive!
    return true if self.archived_at.present?
    self.archived_at = Time.now
    self.save!
  end
end
